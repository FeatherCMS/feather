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
                account_id TEXT NOT NULL,
                email TEXT NOT NULL,
                token TEXT NOT NULL UNIQUE,
                expires_at TIMESTAMPTZ NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                ,FOREIGN KEY(account_id) REFERENCES user_account(id) ON DELETE CASCADE
            );
            """#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }

        // Keep existing installations aligned with the invitation/account model.
        try await connection.run(
            query: #"""
                ALTER TABLE user_invitation
                ADD COLUMN IF NOT EXISTS account_id TEXT;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE user_invitation
                DROP CONSTRAINT IF EXISTS user_invitation_account_id_fkey;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE user_invitation
                ADD CONSTRAINT user_invitation_account_id_fkey
                FOREIGN KEY (account_id) REFERENCES user_account(id) ON DELETE CASCADE;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                DROP TABLE IF EXISTS user_invitation_role;
                """#
        ) { _ in }
    }
}
