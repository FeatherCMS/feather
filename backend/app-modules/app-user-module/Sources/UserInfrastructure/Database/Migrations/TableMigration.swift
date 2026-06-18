import Infrastructure
import FeatherDatabase

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
        let queries: [DatabaseQuery] = [
            // MARK: - account
            #"""
            CREATE TABLE IF NOT EXISTS user_account (
                id TEXT PRIMARY KEY,
                email TEXT NOT NULL,
                password TEXT NOT NULL,
                status TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - role
            #"""
            CREATE TABLE IF NOT EXISTS user_role (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL UNIQUE,
                notes TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - account role
            #"""
            CREATE TABLE IF NOT EXISTS user_account_role (
                role_id TEXT NOT NULL,
                account_id TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL,
                updated_at TIMESTAMPTZ NOT NULL,
                PRIMARY KEY (role_id, account_id),
                FOREIGN KEY(role_id) REFERENCES user_role(id) ON DELETE CASCADE,
                FOREIGN KEY(account_id) REFERENCES user_account(id) ON DELETE CASCADE
            );
            """#,
            // MARK: - invitation
            #"""
            CREATE TABLE IF NOT EXISTS user_invitation (
                id TEXT PRIMARY KEY,
                email TEXT NOT NULL,
                token TEXT NOT NULL UNIQUE,
                expires_at TIMESTAMPTZ NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - invitation role
            #"""
            CREATE TABLE IF NOT EXISTS user_invitation_role (
                invitation_id TEXT NOT NULL,
                role_id TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL,
                updated_at TIMESTAMPTZ NOT NULL,
                PRIMARY KEY (invitation_id, role_id),
                FOREIGN KEY(invitation_id) REFERENCES user_invitation(id) ON DELETE CASCADE,
                FOREIGN KEY(role_id) REFERENCES user_role(id) ON DELETE CASCADE
            );
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
