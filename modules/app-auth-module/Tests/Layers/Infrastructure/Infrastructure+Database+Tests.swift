import AuthApplication
import AuthModule
import FeatherApplication
import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import FeatherTesting
import Foundation
import Testing

@testable import AuthInfrastructure
@testable import FeatherDBAL

private enum QueryKey: DatabaseQueryKey {
    case migration
    case credentialList
    case credentialCount
}

@Suite
struct InfrastructureDatabaseTests {
    @Test
    func migrationCreatesAuthTablesWithRequiredColumnsConstraintsAndIndexes()
        async throws
    {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: (0..<10).map { _ in .init(key: .migration) }
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration] ?? []
        #expect(queries.count == 10)

        let schema = queries.map(\.sql).joined(separator: "\n")
        for table in [
            "auth_session",
            "auth_email",
            "auth_email_credential",
            "auth_magic_link",
            "auth_role_permission",
        ] {
            #expect(schema.contains(table))
        }
    }

    @Test
    func tableSchemasDescribeAllColumnsForeignKeysAndIndexes() {
        let schemas = [
            Email.Table.tableCreationSchema,
            Credential.Table.tableCreationSchema,
            MagicLink.Table.tableCreationSchema,
            RolePermission.Table.tableCreationSchema,
            Session.Table.tableCreationSchema,
        ]
        let expectedColumns: [[String]] = [
            ["id", "identity_id", "email", "created_at", "updated_at"],
            [
                "id", "auth_email_id", "password_hash", "created_at",
                "updated_at",
            ],
            [
                "id", "auth_email_id", "token", "expires_at", "is_persistent",
                "is_used", "created_at", "updated_at",
            ],
            ["role_id", "permission_id", "created_at", "updated_at"],
            [
                "id", "token", "identity_id", "authentication_type",
                "authentication_reference", "is_persistent", "created_at",
                "updated_at", "expires_at",
            ],
        ]

        for index in schemas.indices {
            let schema = schemas[index]
            #expect(schema.columns.map(\.name) == expectedColumns[index])
            #expect(schema.columns.contains { $0.name == "created_at" })
            #expect(schema.columns.contains { $0.name == "updated_at" })
        }

        #expect(hasUniqueConstraint(schemas[0].columns[2].constraints))
        #expect(hasUniqueConstraint(schemas[1].columns[1].constraints))
        #expect(hasUniqueConstraint(schemas[2].columns[2].constraints))
        #expect(hasUniqueConstraint(schemas[4].columns[1].constraints))
        #expect(
            schemas[2].indexes.map(\.name) == [
                "auth_magic_link_auth_email_id_idx"
            ]
        )
        #expect(
            schemas[4].indexes.map(\.name) == ["auth_session_identity_id_idx"]
        )
        #expect(
            schemas[1].constraints
                .contains {
                    if case .foreignKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schemas[2].constraints
                .contains {
                    if case .foreignKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schemas[3].constraints
                .contains {
                    if case .primaryKey(let columns) = $0 {
                        columns.map(\.name) == ["role_id", "permission_id"]
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schemas[3].constraints
                .filter {
                    if case .foreignKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
                .count == 2
        )
    }

    @Test
    func credentialListQueryUsesJoinedSearchAndPagination() async throws {
        let date = Date(timeIntervalSince1970: 1_700_000_000)
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [
                .init(
                    key: .credentialList,
                    rows: [
                        .init([
                            "id": .string("credential-1"),
                            "user_id": .string("identity-1"),
                            "identity_name": .string("Ada Lovelace"),
                            "email": .string("ada@example.test"),
                            "created_at": .date(date),
                            "updated_at": .date(date),
                        ])
                    ]
                ),
                .init(
                    key: .credentialCount,
                    rows: [.init(["count": .int(1)])]
                ),
            ]
        )
        let context = DatabaseQueryContext(
            platform: MockDatabasePlatform(),
            connection: connection,
            idGenerator: FeatherTesting.IDGenerator.Mock(id: "unused")
        )
        let query = Credential.List.Query.Database(context: context)
        let input = Credential.List.Input.Query(
            page: .init(size: 10, number: 2),
            sort: [.init(field: .email, direction: .desc)],
            search: "ada"
        )

        let output = try await query.list(query: input)
        let count = try await query.count(query: input)
        try await connection.assertAllResponsesConsumed()

        #expect(output.items.map(\.email) == ["ada@example.test"])
        #expect(output.items.first?.identityName == "Ada Lovelace")
        #expect(count == 1)
        let queries = await connection.executedQueries()
        let listQuery = try #require(queries[.credentialList]?.first)
        #expect(listQuery.sql.contains("INNER JOIN auth_email"))
        #expect(listQuery.sql.contains("INNER JOIN user_identity"))
        #expect(listQuery.sql.contains("ORDER BY email DESC"))
        #expect(listQuery.sql.contains("LIMIT"))
        #expect(listQuery.sql.contains("OFFSET"))
        #expect(
            listQuery.bindings.contains(where: { $0.binding == .string("ada") })
        )
        #expect(
            queries[.credentialCount]?.first?.sql.contains("COUNT(*)") == true
        )
    }
}

private func hasUniqueConstraint(
    _ constraints: [DatabaseTableColumnConstraintSchema]
) -> Bool {
    constraints.contains { constraint in
        if case .unique = constraint {
            true
        }
        else {
            false
        }
    }
}
