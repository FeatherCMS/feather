import AuthModule
public import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure

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
            AuthEmail.Table.tableCreationSchema,
            Credential.Table.tableCreationSchema,
            MagicLink.Table.tableCreationSchema,
            RolePermission.Table.tableCreationSchema,
            Session.Table.tableCreationSchema,
        ]

        for schema in schemas {
            let queryBuilder = DatabaseQueryCreate(
                schema: schema,
                using: platform
            )
            for query in queryBuilder.build() {
                try await connection.run(query: query) { _ in }
            }
        }
    }
}
