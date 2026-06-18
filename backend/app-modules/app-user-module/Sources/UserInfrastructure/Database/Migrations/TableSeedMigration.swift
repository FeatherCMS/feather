import Infrastructure
import FeatherDatabase
// TODO: eliminate these, use abstractions
import BCrypt
import NIOPosix

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

        let rootPassword = try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash("root")
        }
        let managerPassword = try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash("manager")
        }
        let userPassword = try await NIOThreadPool.singleton.runIfActive {
            try BCrypt().hash("user")
        }

        let queries: [DatabaseQuery] = [
            // MARK: - account
            #"""
            INSERT INTO user_account (
                id,
                email,
                password,
                status,
                created_at,
                updated_at
            )
            VALUES
                ('root', 'mail.tib@gmail.com', \#(rootPassword), 'active', NOW(), NOW()),
                ('manager', 'manager@example.com', \#(managerPassword), 'active', NOW(), NOW()),
                ('user', 'user@example.com', \#(userPassword), 'active', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            // MARK: - role
            #"""
            INSERT INTO user_role (
                id,
                name,
                notes,
                created_at,
                updated_at
            )
            VALUES
                ('root', 'root', '', NOW(), NOW()),
                ('manager', 'manager', '', NOW(), NOW()),
                ('user', 'user', '', NOW(), NOW())
            ON CONFLICT (id) DO NOTHING;
            """#,
            // MARK: - account role
            #"""
            INSERT INTO user_account_role (
                role_id,
                account_id,
                created_at,
                updated_at
            )
            VALUES
                ('root', 'root', NOW(), NOW()),
                ('manager', 'manager', NOW(), NOW()),
                ('user', 'user', NOW(), NOW())
            ON CONFLICT (role_id, account_id) DO NOTHING;
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
