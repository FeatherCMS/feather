import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension AccountTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.email = try row.decode(column: "email", as: String.self)
        self.passwordHash = try row.decode(column: "password", as: String.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.createdAt = try row.decode(
            column: "created_at",
            as: Date.self
        )
        self.updatedAt = try row.decode(
            column: "updated_at",
            as: Date.self
        )
    }
}

struct AccountTable {

    struct Row {
        struct Create {
            let id: String
            let email: String
            let password: String
            let status: String
        }

        let id: String
        let email: String
        let passwordHash: String
        let status: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO user_account (
                    id,
                    email,
                    password,
                    status,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.email),
                    \#(row.password),
                    \#(row.status),
                    NOW(),
                    NOW()
                )
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func list(
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_account
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM user_account
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                );
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return 0
            }
            return try row.decode(column: "count", as: Int.self)
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_account
                WHERE id=\#(id)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(
        email: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_account
                WHERE email=\#(email)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func find(
        sessionToken: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT ua.*
                FROM user_account ua
                INNER JOIN user_session us ON us.account_id = ua.id
                WHERE us.token=\#(sessionToken)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func listRoleNames(
        accountId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT DISTINCT ur.name
                FROM user_role ur
                INNER JOIN user_account_role uar ON uar.role_id = ur.id
                WHERE uar.account_id=\#(accountId)
                ORDER BY ur.name ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "name", as: String.self) }
        }
    }

    func listRoleIds(
        accountId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT uar.role_id
                FROM user_account_role uar
                WHERE uar.account_id=\#(accountId)
                ORDER BY uar.role_id ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "role_id", as: String.self) }
        }
    }

    func listPermissionNames(
        accountId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT DISTINCT sp.name
                FROM system_permission sp
                INNER JOIN auth_role_permission urp ON urp.permission_id = sp.id
                INNER JOIN user_account_role uar ON uar.role_id = urp.role_id
                WHERE uar.account_id=\#(accountId)
                ORDER BY sp.name ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "name", as: String.self) }
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE user_account
                SET
                    id=\#(row.id),
                    email=\#(row.email),
                    password=\#(row.passwordHash),
                    status=\#(row.status),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func delete(
        id: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM user_account WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }

    func replaceRoleIds(
        accountId: String,
        roleIds: [String]
    ) async throws {
        _ = try await connection.run(
            query: #"""
                DELETE FROM user_account_role
                WHERE account_id=\#(accountId);
                """#
        ) { _ in }

        for roleId in roleIds {
            _ = try await connection.run(
                query: #"""
                    INSERT INTO user_account_role (
                        role_id,
                        account_id,
                        created_at,
                        updated_at
                    )
                    VALUES (
                        \#(roleId),
                        \#(accountId),
                        NOW(),
                        NOW()
                    )
                    ON CONFLICT (role_id, account_id) DO NOTHING;
                    """#
            ) { _ in }
        }
    }
}
