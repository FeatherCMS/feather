public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
import MediaModule

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

    public func apply(on connection: any DatabaseConnection) async throws {
        let schemas = [
            Asset.Node.Table.tableCreationSchema,
            Asset.Folder.Table.tableCreationSchema,
            StorageObject.Table.tableCreationSchema,
            Asset.File.Table.tableCreationSchema,
            Variant.Table.tableCreationSchema,
            Variant.Processor.Table.tableCreationSchema,
            Asset.File.Variant.Table.tableCreationSchema,
        ]
        for schema in schemas {
            for query in DatabaseQueryCreate(schema: schema, using: platform)
                .build()
            {
                try await connection.run(query: query) { _ in }
            }
        }
        try await MediaPartialIndexes.apply(on: connection)
    }
}
