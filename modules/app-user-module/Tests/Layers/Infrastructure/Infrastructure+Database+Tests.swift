import FeatherDatabase
import FeatherDatabaseTesting
import FeatherInfrastructure
import Testing

@testable import UserInfrastructure

private enum QueryKey: DatabaseQueryKey {
    case migration
}

@Suite
struct UserInfrastructureDatabaseTests {

    @Test
    func tableMigrationCreatesUserTables() async throws {
        let connection = MockDatabaseConnection<QueryKey>(
            responses: (0..<4).map { _ in .init(key: .migration) }
        )
        let migration = TableMigration(connection: connection)

        try await migration.apply(on: connection)
        try await connection.assertAllResponsesConsumed()

        let queries = await connection.executedQueries()[.migration]
        #expect(queries?.count == 4)
        #expect(queries?.contains { $0.sql.contains("user_identity") } == true)
        #expect(queries?.contains { $0.sql.contains("user_role") } == true)
        #expect(
            queries?.contains { $0.sql.contains("user_identity_role") }
                == true
        )
    }
}
