public import FeatherDatabase
public import FeatherInfrastructure

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext
    ) {
        self.context = context
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        try await applyInsightsPermissionSeedMigration(on: context.connection)
        try await applyNotFoundPermissionSeedMigration(on: context.connection)
    }

    private func applyInsightsPermissionSeedMigration(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
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
            WHERE sp.key IN (
                'analytics:insights:list'
            )
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }

    private func applyNotFoundPermissionSeedMigration(
        on connection: any DatabaseConnection
    ) async throws {
        let queries: [DatabaseQuery] = [
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
            WHERE sp.key = 'analytics:not-found:list'
            ON CONFLICT (role_id, permission_id) DO NOTHING;
            """#
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }

}
