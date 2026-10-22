public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import WebDomain
import WebModule

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
        for schema in [
            Page.Table.tableCreationSchema,
            Menu.Table.tableCreationSchema,
            MenuItem.Table.tableCreationSchema,
            Metadata.Table.tableCreationSchema,
        ] {
            for query in DatabaseQueryCreate(schema: schema, using: platform)
                .build()
            {
                try await connection.run(query: query) { _ in }
            }
        }

    }
}
