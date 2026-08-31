//
//  IdentityTable.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension IdentityTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.status = try row.decode(column: "status", as: String.self)
        self.isRoot = try row.decode(column: "is_root", as: Bool.self)
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

struct IdentityTable {

    struct Row {
        struct Create {
            let id: String
            let status: String
            let isRoot: Bool
        }

        let id: String
        let status: String
        let isRoot: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO user_identity (
                    id,
                    status,
                    is_root,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.status),
                    \#(row.isRoot),
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
        role: String? = nil,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT ui.*
                FROM user_identity ui
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (\#(role == nil) OR EXISTS (
                    SELECT 1 FROM user_identity_role uir
                    INNER JOIN user_role ur ON ur.id=uir.role_id
                    WHERE uir.identity_id=ui.id
                    AND (LOWER(ur.id)=LOWER(\#(role ?? ""))
                         OR LOWER(COALESCE(ur.name, ''))=LOWER(\#(role ?? "")))
                ))
                ORDER BY \#(unescaped: orderBy)
                LIMIT \#(limit)
                OFFSET \#(offset);
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func count(
        search: String?,
        role: String? = nil
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM user_identity
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(status) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                )
                AND (\#(role == nil) OR EXISTS (
                    SELECT 1 FROM user_identity_role uir
                    INNER JOIN user_role ur ON ur.id=uir.role_id
                    WHERE uir.identity_id=user_identity.id
                    AND (LOWER(ur.id)=LOWER(\#(role ?? ""))
                         OR LOWER(COALESCE(ur.name, ''))=LOWER(\#(role ?? "")))
                ));
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
                FROM user_identity
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

    func findRoot() async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM user_identity
                WHERE is_root=TRUE
                ORDER BY created_at ASC
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
        identityId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT DISTINCT ur.name
                FROM user_role ur
                INNER JOIN user_identity_role uar ON uar.role_id = ur.id
                WHERE uar.identity_id=\#(identityId)
                ORDER BY ur.name ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .compactMap { try $0.decode(column: "name", as: String?.self) }
        }
    }

    func listRoleIds(
        identityId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT uar.role_id
                FROM user_identity_role uar
                WHERE uar.identity_id=\#(identityId)
                ORDER BY uar.role_id ASC;
                """#
        ) { sequence in
            try await sequence.collect()
                .map { try $0.decode(column: "role_id", as: String.self) }
        }
    }

    func listPermissionNames(
        identityId: String
    ) async throws -> [String] {
        try await connection.run(
            query: #"""
                SELECT DISTINCT sp.name
                FROM system_permission sp
                WHERE EXISTS (
                    SELECT 1 FROM user_identity ui
                    WHERE ui.id=\#(identityId) AND ui.is_root=TRUE
                )
                OR EXISTS (
                    SELECT 1
                    FROM auth_role_permission urp
                    INNER JOIN user_identity_role uar
                        ON uar.role_id = urp.role_id
                    WHERE urp.permission_id = sp.id
                    AND uar.identity_id=\#(identityId)
                )
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
                UPDATE user_identity
                SET
                    id=\#(row.id),
                    status=\#(row.status),
                    is_root=\#(row.isRoot),
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
                DELETE FROM user_identity WHERE id=\#(id) RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().first != nil
        }
    }

    func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws {
        _ = try await connection.run(
            query: #"""
                DELETE FROM user_identity_role
                WHERE identity_id=\#(identityId);
                """#
        ) { _ in }

        for roleId in roleIds {
            _ = try await connection.run(
                query: #"""
                    INSERT INTO user_identity_role (
                        role_id,
                        identity_id,
                        created_at,
                        updated_at
                    )
                    VALUES (
                        \#(roleId),
                        \#(identityId),
                        NOW(),
                        NOW()
                    )
                    ON CONFLICT (role_id, identity_id) DO NOTHING;
                    """#
            ) { _ in }
        }
    }
}
