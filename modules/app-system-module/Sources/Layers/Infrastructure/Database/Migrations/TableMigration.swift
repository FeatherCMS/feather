import FeatherDatabase
import FeatherInfrastructure

public struct TableMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await applyTableMigration(on: connection)
    }

    private func applyTableMigration(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            // MARK: - permission
            #"""
            CREATE TABLE IF NOT EXISTS system_permission (
                id TEXT PRIMARY KEY,
                name TEXT,
                notes TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - variable
            #"""
            CREATE TABLE IF NOT EXISTS system_variable (
                id TEXT PRIMARY KEY,
                value TEXT NOT NULL,
                name TEXT,
                notes TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }

}
