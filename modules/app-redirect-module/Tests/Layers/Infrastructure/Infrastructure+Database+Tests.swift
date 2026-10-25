import FeatherDBALTesting
import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import RedirectModule
import Testing

@testable import FeatherDBAL
@testable import RedirectInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct RedirectInfrastructureDatabaseTests {
    @Test
    func tableMigrationCreatesRuleSchema() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: [.init(key: .migration)]
        )
        let migration = TableMigration(
            connection: connection,
            platform: MockDatabasePlatform()
        )

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration]
        #expect(queries?.count == 1)
        #expect(queries?.first?.sql.contains("CREATE TABLE") == true)
        #expect(queries?.first?.sql.contains("redirect_rule") == true)
    }

    @Test
    func tableSchemaDeclaresColumnsAndConstraints() {
        let schema = Rule.Table.tableCreationSchema

        #expect(schema.name == "redirect_rule")
        #expect(
            schema.columns.map(\.name) == [
                "id", "source", "destination", "status_code", "notes",
                "created_at", "updated_at",
            ]
        )
        #expect(
            schema.columns[0].constraints
                .contains {
                    if case .primaryKey = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[1].constraints
                .contains {
                    if case .unique = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(schema.columns[0].type == .string)
        #expect(schema.columns[1].type == .string)
        #expect(schema.columns[2].type == .string)
        #expect(schema.columns[3].type == .integer)
        #expect(schema.columns[4].type == .string)
        #expect(schema.columns[5].type == .timestamp)
        #expect(schema.columns[6].type == .timestamp)
        #expect(
            schema.columns[1].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[2].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[3].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[5].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[6].constraints
                .contains {
                    if case .notNull = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[5].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        #expect(
            schema.columns[6].constraints
                .contains {
                    if case .default = $0 {
                        true
                    }
                    else {
                        false
                    }
                }
        )
        for column in [schema.columns[5], schema.columns[6]] {
            #expect(column.constraints.contains {
                guard case .default(let value) = $0 else { return false }
                if case .currentTimestamp = value.storage { return true }
                return false
            })
        }
        #expect(schema.indexes.isEmpty)
    }
}
