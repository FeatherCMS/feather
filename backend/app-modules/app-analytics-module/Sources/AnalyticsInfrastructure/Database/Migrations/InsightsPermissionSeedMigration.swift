import FeatherDatabase
import Infrastructure

public struct InsightsPermissionSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection

    public init(connection: any DatabaseConnection) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
            #"""
            INSERT INTO system_permission (
                id,
                name,
                notes,
                created_at,
                updated_at
            )
            VALUES
                ('analytics:insights:list', 'analytics:insights:list', 'View analytics overview and insights dashboards.', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            #"""
            INSERT INTO auth_role_permission (
                role_id,
                permission_id,
                created_at,
                updated_at
            )
            SELECT
                ur.id,
                sp.id,
                NOW(),
                NOW()
            FROM system_permission sp
            INNER JOIN user_role ur
                ON ur.id = 'root'
            WHERE sp.id IN (
                'analytics:insights:list'
            )
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
