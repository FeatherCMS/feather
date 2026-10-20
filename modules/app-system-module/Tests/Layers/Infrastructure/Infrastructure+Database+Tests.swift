import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherDomain
import FeatherInfrastructure
import FeatherTesting
import Foundation
import SystemApplication
import SystemDomain
import SystemModule
import Testing

@testable import SystemInfrastructure

private enum QueryKeys {
    enum Variable: DatabaseQueryKey {
        case insert
        case find
        case update
        case delete
        case list
        case count
        case createTable
    }

    enum Permission: DatabaseQueryKey {
        case insert
        case update
        case find
        case createTable
    }

    enum Job: DatabaseQueryKey {
        case search
        case count
    }
}

@Suite
struct InfrastructureDatabaseTests {

    @Test
    func mockConnectionRecordsMultipleQueriesForTheSameKey() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Variable>(responses: [
            .init(key: .insert),
            .init(key: .insert),
        ])

        for sql in ["INSERT INTO first_table", "INSERT INTO second_table"] {
            try await connection.run(query: .init(unsafeSQL: sql)) { _ in }
        }
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()
        #expect(
            queries[.insert]?.map(\.sql)
                == ["INSERT INTO first_table", "INSERT INTO second_table"]
        )
    }

    @Test
    func variableRepositoryBuildsCrudQueriesAndMapsRows() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Variable>(
            responses: [
                .init(key: .insert),
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("variable-1"),
                            "key": .string("test.key"),
                            "value": .string("before"),
                            "name": .string("Test"),
                            "notes": .null,
                        ])
                    ]
                ),
                .init(key: .update),
                .init(key: .delete),
            ])
        let context = DatabaseTransactionContext(
            platform: MockDatabasePlatform(),
            connection: connection,
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "variable-1")
        )
        let repository = SystemModule.Variable.Repository.Database(
            context: context
        )

        let inserted = try await repository.insert(
            try SystemModule.Variable.Model.create(
                key: "test.key",
                value: "before",
                name: "Test",
                notes: nil
            )
        )
        #expect(inserted.id == "variable-1")

        let loaded = try await repository.find(id: "variable-1")
        #expect(loaded?.key == "test.key")
        #expect(loaded?.notes == nil)

        var edited = inserted
        edited.value = "after"
        #expect(try await repository.update(edited).value == "after")
        try await repository.delete(ids: [inserted.id])
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()
        #expect(queries.values.reduce(0) { $0 + $1.count } == 4)
        #expect(
            queries[.insert]?.first?.sql.contains("INSERT INTO") == true
        )
        #expect(queries[.find]?.first?.sql.contains("SELECT") == true)
        #expect(queries[.update]?.first?.sql.contains("UPDATE") == true)
        #expect(
            queries[.delete]?.first?.sql.contains("DELETE FROM") == true
        )
        #expect(
            queries.values.flatMap { $0 }.allSatisfy { !$0.bindings.isEmpty }
        )
    }

    @Test
    func permissionRepositoryUsesIDForLookupAndPersistsKey() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Permission>(
            responses: [
                .init(key: .insert),
                .init(key: .update),
                .init(
                    key: .find,
                    rows: [
                        .init([
                            "id": .string("permission-1"),
                            "key": .string("system.permission.updated"),
                            "name": .null,
                            "notes": .string("Notes"),
                        ])
                    ]
                ),
            ])
        let context = DatabaseTransactionContext(
            platform: MockDatabasePlatform(),
            connection: connection,
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "permission-1")
        )
        let repository = SystemModule.Permission.Repository.Database(
            context: context
        )
        let inserted = try await repository.insert(
            try SystemModule.Permission.Model.create(
                key: "system.permission",
                name: nil,
                notes: "Notes"
            )
        )

        var edited = inserted
        edited.key = "system.permission.updated"
        _ = try await repository.update(edited)
        let loaded = try await repository.find(id: inserted.id)
        try await connection.assertAllResponsesConsumed()

        #expect(loaded?.key == "system.permission.updated")
        #expect(loaded?.name == nil)
        let queries = await connection.executedQueries()
        #expect(queries.values.reduce(0) { $0 + $1.count } == 3)
        #expect(
            queries[.update]?.first?.sql.contains("UPDATE") == true
        )
        #expect(
            queries[.find]?.first?.sql.contains("SELECT") == true
        )
        #expect(
            queries[.find]?.first?.bindings
                .contains(.init(index: 0, binding: .string("permission-1")))
                == true
        )
    }

    @Test
    func tableMigrationEmitsBothTableCreationQueries() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Permission>(
            responses: [
                .init(key: .createTable),
                .init(key: .createTable),
            ])
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()
        #expect(queries.values.reduce(0) { $0 + $1.count } == 2)
        #expect(queries[.createTable]?.count == 2)
        #expect(
            queries[.createTable]?
                .contains {
                    $0.sql.contains("system_permission")
                } == true
        )
        #expect(
            queries[.createTable]?
                .contains {
                    $0.sql.contains("system_variable")
                } == true
        )
    }

    @Test
    func variableListAndCountUseFiltersOrderingAndPagination() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Variable>(
            responses: [
                .init(
                    key: .list,
                    rows: [
                        .init([
                            "id": .string("variable-1"),
                            "key": .string("mail.from"),
                            "value": .string("noreply@example.test"),
                            "name": .null,
                            "notes": .null,
                        ])
                    ]
                ),
                .init(
                    key: .count,
                    rows: [
                        .init(["count": .int(1)])
                    ]
                ),
            ])
        let query = SystemModule.Variable.List.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )
        let input = SystemModule.Variable.List.Input.Query(
            page: .init(size: 10, number: 2),
            search: "mail",
            ids: ["variable-1"]
        )

        let list = try await query.list(query: input)
        let count = try await query.count(query: input)
        try await connection.assertAllResponsesConsumed()

        #expect(list.items.map(\.key) == ["mail.from"])
        #expect(count == 1)
        let queries = await connection.executedQueries()
        #expect(queries.values.reduce(0) { $0 + $1.count } == 2)
        #expect(queries[.list]?.first?.sql.contains("WHERE") == true)
        #expect(
            queries[.list]?.first?.sql.contains("ORDER BY") == true
        )
        #expect(queries[.list]?.first?.sql.contains("LIMIT") == true)
        #expect(queries[.list]?.first?.sql.contains("OFFSET") == true)
        #expect((queries[.list]?.first?.bindings.count ?? 0) >= 3)
        #expect(queries[.count]?.first?.sql.contains("COUNT") == true)
    }

    @Test
    func jobSearchUsesBoundSearchAndStatusFilters() async throws {
        let connection = MockDatabaseConnection<QueryKeys.Job>(
            responses: [
                .init(
                    key: .search,
                    rows: [
                        .init([
                            "id": .string("job-1"),
                            "queue_name": .string("default"),
                            "status": .int(3),
                            "worker_id": .null,
                            "last_modified": .date(
                                Date(timeIntervalSince1970: 1_700_000_000)
                            ),
                            "payload": .string("{}"),
                        ])
                    ]
                ),
                .init(key: .count, rows: [.init(["count": .int(1)])]),
            ]
        )
        let query = SystemModule.Job.Search.Query.Database(
            context: DatabaseQueryContext(
                platform: MockDatabasePlatform(),
                connection: connection,
                idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
            )
        )

        let result = try await query.search(
            query: .init(
                page: .init(size: 20, number: 2),
                search: "queue_50%",
                status: 3
            )
        )
        try await connection.assertAllResponsesConsumed()

        #expect(result.items.map(\.id) == ["job-1"])
        #expect(result.total == 1)
        let queries = await connection.executedQueries()
        let select = try #require(queries[.search]?.first)
        #expect(select.sql.contains("ILIKE"))
        #expect(select.sql.contains("jsonb_each"))
        #expect(select.sql.contains("NULLS LAST"))
        #expect(select.sql.contains("LIMIT"))
        #expect(select.sql.contains("OFFSET"))
        #expect(
            select.bindings.contains(
                .init(index: 0, binding: .string("%queue!_50!%%"))
            )
        )
        #expect(select.bindings.contains(where: { $0.binding == .int(3) }))
        #expect(queries[.count]?.first?.sql.contains("COUNT(*)") == true)
    }
}
