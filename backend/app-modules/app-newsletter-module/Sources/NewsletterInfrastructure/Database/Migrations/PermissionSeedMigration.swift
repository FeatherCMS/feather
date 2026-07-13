import FeatherDatabase
import Infrastructure

public struct PermissionSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(on connection: any DatabaseConnection) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            INSERT INTO system_permission (id, name, notes, created_at, updated_at)
            VALUES
                ('newsletter:campaigns:create', 'newsletter:campaigns:create', 'Create a newsletter campaign.', NOW(), NOW()),
                ('newsletter:campaigns:read', 'newsletter:campaigns:read', 'View a newsletter campaign.', NOW(), NOW()),
                ('newsletter:campaigns:update', 'newsletter:campaigns:update', 'Edit a newsletter campaign.', NOW(), NOW()),
                ('newsletter:campaigns:list', 'newsletter:campaigns:list', 'List newsletter campaigns.', NOW(), NOW()),
                ('newsletter:campaigns:delete', 'newsletter:campaigns:delete', 'Delete a newsletter campaign.', NOW(), NOW()),
                ('newsletter:subscribers:create', 'newsletter:subscribers:create', 'Add a newsletter subscriber.', NOW(), NOW()),
                ('newsletter:subscribers:read', 'newsletter:subscribers:read', 'View a newsletter subscriber.', NOW(), NOW()),
                ('newsletter:subscribers:update', 'newsletter:subscribers:update', 'Edit a newsletter subscriber.', NOW(), NOW()),
                ('newsletter:subscribers:list', 'newsletter:subscribers:list', 'List newsletter subscribers.', NOW(), NOW()),
                ('newsletter:subscribers:delete', 'newsletter:subscribers:delete', 'Delete a newsletter subscriber.', NOW(), NOW()),
                ('newsletter:issues:create', 'newsletter:issues:create', 'Create a newsletter issue.', NOW(), NOW()),
                ('newsletter:issues:read', 'newsletter:issues:read', 'View a newsletter issue.', NOW(), NOW()),
                ('newsletter:issues:update', 'newsletter:issues:update', 'Edit a newsletter issue.', NOW(), NOW()),
                ('newsletter:issues:list', 'newsletter:issues:list', 'List newsletter issues.', NOW(), NOW()),
                ('newsletter:issues:delete', 'newsletter:issues:delete', 'Delete a newsletter issue.', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            #"""
            INSERT INTO auth_role_permission (role_id, permission_id, created_at, updated_at)
            SELECT 'root', id, NOW(), NOW()
            FROM system_permission
            WHERE id LIKE 'newsletter:%'
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
