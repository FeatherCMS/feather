public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import NewsModule

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    public let platform: any DatabasePlatform

    public init(connection: any DatabaseConnection, platform: any DatabasePlatform) {
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
        let schemas = [
            Article.Table.tableCreationSchema,
            Category.Table.tableCreationSchema,
            Article.CategoryTable.tableCreationSchema,
        ]

        for schema in schemas {
            let queryBuilder = DatabaseQueryCreate(schema: schema, using: platform)
            for query in queryBuilder.build() {
                try await connection.run(query: query) { _ in }
            }
        }
    }

}
