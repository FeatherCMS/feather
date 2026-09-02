//
//  MagicLinkTable.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension MagicLinkTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.credentialId = try row.decode(
            column: "credential_id",
            as: String.self
        )
        self.token = try row.decode(column: "token", as: String.self)
        self.expiresAt = try row.decode(
            column: "expires_at",
            as: Date.self
        )
        self.isPersistent = try row.decode(
            column: "is_persistent",
            as: Bool.self
        )
        self.isUsed = try row.decode(column: "is_used", as: Bool.self)
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

struct MagicLinkTable {

    struct Row {
        struct Create {
            let id: String
            let credentialId: String
            let token: String
            let expiresAtInterval: Double
            let isPersistent: Bool
            let isUsed: Bool
        }

        let id: String
        let credentialId: String
        let token: String
        let expiresAt: Date
        let isPersistent: Bool
        let isUsed: Bool
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO auth_magic_link (
                    id,
                    credential_id,
                    token,
                    expires_at,
                    is_persistent,
                    is_used,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.credentialId),
                    \#(row.token),
                    NOW() + (\#(row.expiresAtInterval) * INTERVAL '1 second'),
                    \#(row.isPersistent),
                    \#(row.isUsed),
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
        userId: String? = nil,
        search: String?,
        orderBy: String,
        limit: Int,
        offset: Int
    ) async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT magic_link.*
                FROM auth_magic_link AS magic_link
                INNER JOIN auth_credentials AS credential
                    ON credential.id=magic_link.credential_id
                WHERE (
                    \#(userId == nil)
                    OR credential.user_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(magic_link.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(magic_link.credential_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(magic_link.token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(magic_link.expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(CAST(magic_link.is_persistent AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(CAST(magic_link.is_used AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
        userId: String? = nil,
        search: String?
    ) async throws -> Int {
        try await connection.run(
            query: #"""
                SELECT COUNT(*) AS count
                FROM auth_magic_link AS magic_link
                INNER JOIN auth_credentials AS credential
                    ON credential.id=magic_link.credential_id
                WHERE (
                    \#(userId == nil)
                    OR credential.user_id=\#(userId ?? "")
                )
                AND (
                    \#(search == nil)
                    OR LOWER(magic_link.id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(magic_link.credential_id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(magic_link.token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(magic_link.expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
                    OR LOWER(CAST(magic_link.is_persistent AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(CAST(magic_link.is_used AS TEXT)) LIKE '%' || LOWER(\#(search ?? "")) || '%'
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
                FROM auth_magic_link
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
        token: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_magic_link
                WHERE token=\#(token)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func consume(
        token: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_magic_link
                SET
                    is_used=TRUE,
                    updated_at=NOW()
                WHERE
                    token=\#(token)
                    AND is_used=FALSE
                    AND expires_at>NOW()
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                return nil
            }
            return try Row(from: row)
        }
    }

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_magic_link
                SET
                    id=\#(row.id),
                credential_id=\#(row.credentialId),
                    token=\#(row.token),
                    expires_at=TO_TIMESTAMP(\#(row.expiresAt.timeIntervalSince1970)),
                    is_persistent=\#(row.isPersistent),
                    is_used=\#(row.isUsed),
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
        ids: [String]
    ) async throws -> [String] {
        guard !ids.isEmpty else { return [] }
        let values =
            ids.map {
                "'\($0.replacingOccurrences(of: "'", with: "''"))'"
            }
            .joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM auth_magic_link
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect()
                .map {
                    try $0.decode(column: "id", as: String.self)
                }
        }
    }
}
