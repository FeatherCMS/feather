import FeatherDatabase

struct AnalyticsPermissionSeed {
    let connection: any DatabaseConnection

    func apply() async throws {
        for permissionKey in ["analytics:insights:list", "analytics:not-found:list"] {
            try await connection.run(
                query: #"""
                    INSERT INTO auth_role_permission (
                        role_id, permission_id, created_at, updated_at
                    )
                    SELECT role.id, permission.id, NOW(), NOW()
                    FROM system_permission AS permission
                    INNER JOIN user_role AS role ON role.id = 'root'
                    WHERE permission.key = \#(permissionKey)
                    ON CONFLICT (role_id, permission_id) DO NOTHING;
                    """#
            ) { _ in }
        }
    }
}
