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
        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS redirect_rule (
                    id TEXT PRIMARY KEY,
                    source TEXT NOT NULL UNIQUE,
                    destination TEXT NOT NULL,
                    status_code INTEGER NOT NULL,
                    notes TEXT,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                );
                """#
        ) { _ in }
    }

}
