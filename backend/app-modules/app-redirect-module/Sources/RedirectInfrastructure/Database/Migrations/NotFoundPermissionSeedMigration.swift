import FeatherDatabase
import Infrastructure

public struct NotFoundPermissionSeedMigration: DatabaseMigration {
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
                ('redirect:not-found:list', 'redirect:not-found:list', 'View 404 and missing-route reports.', NOW(), NOW())
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
                'redirect:not-found:list'
            )
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
