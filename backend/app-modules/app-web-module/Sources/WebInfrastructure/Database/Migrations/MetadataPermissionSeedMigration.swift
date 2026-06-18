import Infrastructure
import FeatherDatabase

public struct MetadataPermissionSeedMigration: DatabaseMigration {

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
            #"""
            UPDATE system_permission
            SET
                id = REPLACE(id, 'metadata:entries:', 'web:metadata:'),
                name = REPLACE(name, 'metadata:entries:', 'web:metadata:')
            WHERE id LIKE 'metadata:entries:%';
            """#,
            #"""
            INSERT INTO system_permission (
                id,
                name,
                notes,
                created_at,
                updated_at
            )
            VALUES
                ('web:metadata:create', 'web:metadata:create', 'Create web metadata.', NOW(), NOW()),
                ('web:metadata:read', 'web:metadata:read', 'View web metadata.', NOW(), NOW()),
                ('web:metadata:update', 'web:metadata:update', 'Edit web metadata.', NOW(), NOW()),
                ('web:metadata:list', 'web:metadata:list', 'List and search web metadata.', NOW(), NOW()),
                ('web:metadata:delete', 'web:metadata:delete', 'Delete web metadata.', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            #"""
            UPDATE auth_role_permission
            SET permission_id = REPLACE(permission_id, 'metadata:entries:', 'web:metadata:')
            WHERE permission_id LIKE 'metadata:entries:%';
            """#,
            #"""
            INSERT INTO auth_role_permission (
                role_id,
                permission_id,
                created_at,
                updated_at
            )
            SELECT
                'root',
                sp.id,
                NOW(),
                NOW()
            FROM system_permission sp
            WHERE sp.id IN (
                'web:metadata:create',
                'web:metadata:read',
                'web:metadata:update',
                'web:metadata:list',
                'web:metadata:delete'
            )
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
