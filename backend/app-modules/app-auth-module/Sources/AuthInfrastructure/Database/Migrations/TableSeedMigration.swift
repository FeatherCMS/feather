import Infrastructure
import FeatherDatabase

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {

        let queries: [DatabaseQuery] = [
            // MARK: - role permission
            #"""
            INSERT INTO auth_role_permission (
                role_id,
                permission_id,
                created_at,
                updated_at
            )
            SELECT
                'root',
                id,
                NOW(),
                NOW()
            FROM system_permission
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,

            #"""
            INSERT INTO auth_role_permission (
                role_id,
                permission_id,
                created_at,
                updated_at
            )
            SELECT
                v.role_id,
                v.permission_id,
                NOW(),
                NOW()
            FROM (
                VALUES
                    ('manager', 'auth:admin:access'),
                    ('user', 'auth:profile:read'),
                    ('user', 'auth:profile:update'),
                    ('user', 'auth:settings:read'),
                    ('user', 'auth:settings:update'),
                    ('manager', 'auth:profile:read'),
                    ('manager', 'auth:profile:update'),
                    ('manager', 'auth:settings:read'),
                    ('manager', 'auth:settings:update'),
                    ('manager', 'user:accounts:list'),
                    ('manager', 'user:accounts:read'),
                    ('manager', 'user:accounts:create'),
                    ('manager', 'user:accounts:update'),
                    ('manager', 'user:accounts:delete'),
                    ('manager', 'user:roles:read'),
                    ('manager', 'user:invitations:read'),
                    ('manager', 'media:assets:create'),
                    ('manager', 'media:assets:read'),
                    ('manager', 'media:assets:update'),
                    ('manager', 'media:assets:list'),
                    ('manager', 'media:assets:delete'),
                    ('manager', 'media:processors:create'),
                    ('manager', 'media:processors:read'),
                    ('manager', 'media:processors:list'),
                    ('manager', 'media:processors:update'),
                    ('manager', 'media:processors:delete')
            ) AS v(role_id, permission_id)
            INNER JOIN system_permission sp ON sp.id = v.permission_id
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
