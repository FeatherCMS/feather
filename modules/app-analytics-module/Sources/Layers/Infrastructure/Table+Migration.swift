public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import AnalyticsModule

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    public let platform: any DatabasePlatform

    public init(
        connection: any DatabaseConnection,
        platform: any DatabasePlatform
    ) {
        self.connection = connection
        self.platform = platform
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await applyTableMigration(on: connection)
    }

    private func applyTableMigration(
        on connection: any DatabaseConnection
    ) async throws {
        let queryBuilder = DatabaseQueryCreate(
            schema: Log.Table.tableCreationSchema,
            using: platform
        )
        for query in queryBuilder.build() {
            try await connection.run(query: query) { _ in }
        }
    }

}
