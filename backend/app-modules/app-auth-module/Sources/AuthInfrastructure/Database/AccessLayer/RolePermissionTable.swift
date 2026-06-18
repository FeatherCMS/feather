import FeatherDatabase
import Infrastructure
import struct Foundation.Date

extension RolePermissionTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.roleId = try row.decode(
            column: "role_id",
            as: String.self
        )

        self.permissionId = try row.decode(
            column: "permission_id",
            as: String.self
        )

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

struct RolePermissionTable {

    struct Row {
        let roleId: String
        let permissionId: String
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO auth_role_permission (
                    role_id,
                    permission_id,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.roleId),
                    \#(row.permissionId),
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
                FROM auth_role_permission
                WHERE (
                    \#(search == nil)
                    OR LOWER(role_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(permission_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM auth_role_permission
                WHERE (
                    \#(search == nil)
                    OR LOWER(role_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(permission_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
        roleId: String,
        permissionId: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_role_permission
                WHERE role_id=\#(roleId)
                AND permission_id=\#(permissionId)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func update(
        roleId: String,
        permissionId: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_role_permission
                SET
                    role_id=\#(row.roleId),
                    permission_id=\#(row.permissionId),
                    updated_at=NOW()
                WHERE role_id=\#(roleId)
                AND permission_id=\#(permissionId)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func listPermissionIds(
        roleId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT permission_id
                FROM auth_role_permission
                WHERE role_id=\#(roleId)
                ORDER BY permission_id ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "permission_id", as: String.self) }
        }
    }

    func delete(
        roleId: String,
        permissionId: String
    ) async throws -> Bool {
        try await connection.run(
            query: #"""
                DELETE FROM auth_role_permission
                WHERE role_id=\#(roleId)
                AND permission_id=\#(permissionId)
                RETURNING role_id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }
}
