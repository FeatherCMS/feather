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
            // MARK: - session
            #"""
            CREATE TABLE IF NOT EXISTS user_session (
                id TEXT PRIMARY KEY,
                token TEXT NOT NULL UNIQUE,
                account_id TEXT NOT NULL,
                is_persistent BOOLEAN NOT NULL DEFAULT FALSE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                expires_at TIMESTAMPTZ NOT NULL,
                FOREIGN KEY(account_id) REFERENCES user_account(id) ON DELETE CASCADE
            );
            """#,
            // MARK: - magic link
            #"""
            CREATE TABLE IF NOT EXISTS user_magic_link (
                id TEXT PRIMARY KEY,
                email TEXT NOT NULL,
                token TEXT NOT NULL UNIQUE,
                expires_at TIMESTAMPTZ NOT NULL,
                is_persistent BOOLEAN NOT NULL DEFAULT FALSE,
                is_used BOOLEAN NOT NULL DEFAULT FALSE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - role permission
            #"""
            CREATE TABLE IF NOT EXISTS auth_role_permission (
                role_id TEXT NOT NULL,
                permission_id TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL,
                updated_at TIMESTAMPTZ NOT NULL,
                PRIMARY KEY (role_id, permission_id),
                FOREIGN KEY(role_id) REFERENCES user_role(id) ON DELETE CASCADE,
                FOREIGN KEY(permission_id) REFERENCES system_permission(id) ON DELETE CASCADE
            );
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
