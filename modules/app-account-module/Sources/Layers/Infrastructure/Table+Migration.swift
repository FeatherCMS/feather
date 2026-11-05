import AccountModule
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
            Profile.Table.tableCreationSchema,
            Settings.Table.tableCreationSchema,
            Invitation.Table.tableCreationSchema,
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
        try await Settings.Table.applyPageSizeConstraint(on: connection)
    }
}

extension Settings.Table {
    static func applyPageSizeConstraint(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
                DO $$ BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM pg_constraint
                        WHERE conname = 'account_settings_page_size_check'
                          AND conrelid = 'account_settings'::regclass
                    ) THEN
                        ALTER TABLE account_settings
                        ADD CONSTRAINT account_settings_page_size_check
                        CHECK (page_size IN (10, 20, 50, 100));
                    END IF;
                END $$;
                """#
        ) { _ in }
    }
}
