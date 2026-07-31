import FeatherDatabase
import Infrastructure

public struct JobPermissionSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await connection.run(
            query: #"""
                INSERT INTO system_permission (id, name, notes, created_at, updated_at)
                VALUES
                    ('system:jobs:read', 'system:jobs:read', 'View a worker job.', NOW(), NOW()),
                    ('system:jobs:list', 'system:jobs:list', 'List worker jobs.', NOW(), NOW())
                ON CONFLICT (id) DO NOTHING;
                """#
        ) { _ in }
    }
}
