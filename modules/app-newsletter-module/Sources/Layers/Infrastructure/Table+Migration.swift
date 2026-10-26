public import FeatherDatabase
public import FeatherDBAL
public import FeatherInfrastructure
import NewsletterModule

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    public let platform: any DatabasePlatform

    public init(connection: any DatabaseConnection, platform: any DatabasePlatform) {
        self.connection = connection
        self.platform = platform
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let schemas = [
            Campaign.Table.tableCreationSchema,
            Subscriber.Table.tableCreationSchema,
            Issue.Table.tableCreationSchema,
            Delivery.Table.tableCreationSchema,
        ]
        for schema in schemas {
            for query in DatabaseQueryCreate(schema: schema, using: platform).build() {
                try await connection.run(query: query) { _ in }
            }
        }
        try await NewsletterStatusConstraints.apply(on: connection)
    }
}
