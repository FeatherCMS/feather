//
//  InvitationTable.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Data
import struct Foundation.Date
import class Foundation.JSONDecoder
import class Foundation.JSONEncoder

extension InvitationTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.userId = try row.decode(column: "user_id", as: String.self)
        self.email = try row.decode(column: "email", as: String.self)
        self.token = try row.decode(column: "token", as: String.self)
        let roleIDs = try row.decode(column: "role_ids", as: String.self)
        self.roleIDs = try JSONDecoder()
            .decode(
                [String].self,
                from: Data(roleIDs.utf8)
            )
        self.expiresAt = try row.decode(
            column: "expires_at",
            as: Date.self
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

struct InvitationTable {

    struct Row {
        struct Create {
            let id: String
            let userId: String
            let email: String
            let token: String
            let roleIDs: [String]
            let expiresAtInterval: Double
        }

        let id: String
        let userId: String
        let email: String
        let token: String
        let roleIDs: [String]
        let expiresAt: Date
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        let roleIDs = String(
            decoding: try JSONEncoder().encode(row.roleIDs),
            as: UTF8.self
        )
        return try await connection.run(
            query: #"""
                INSERT INTO account_invitation (
                    id,
                    user_id,
                    email,
                    token,
                    role_ids,
                    expires_at,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.userId),
                    \#(row.email),
                    \#(row.token),
                    \#(roleIDs),
                    NOW() + (\#(row.expiresAtInterval) * INTERVAL '1 second'),
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
                FROM account_invitation
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
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
                FROM account_invitation
                WHERE (
                    \#(search == nil)
                    OR LOWER(id) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(email) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR LOWER(token) LIKE '%' || LOWER(\#(search ?? "")) || '%'
                    OR CAST(expires_at AS TEXT) LIKE '%' || \#(search ?? "") || '%'
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
                FROM account_invitation
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
                SELECT * FROM account_invitation WHERE token=\#(token) LIMIT 1;
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
        let roleIDs = String(
            decoding: try JSONEncoder().encode(row.roleIDs),
            as: UTF8.self
        )
        return try await connection.run(
            query: #"""
                UPDATE account_invitation
                SET
                    id=\#(row.id),
                    user_id=\#(row.userId),
                    email=\#(row.email),
                    token=\#(row.token),
                    role_ids=\#(roleIDs),
                    expires_at=TO_TIMESTAMP(\#(row.expiresAt.timeIntervalSince1970)),
                    updated_at=NOW()
                WHERE id=\#(id)
                RETURNING *;
                """#
        ) { sequence -> Row? in
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
        let values = ids.map {
            "'\($0.replacingOccurrences(of: "'", with: "''"))'"
        }.joined(separator: ", ")
        return try await connection.run(
            query: #"""
                DELETE FROM account_invitation
                WHERE id IN (\#(unescaped: values))
                RETURNING id;
                """#
        ) { sequence in
            try await sequence.collect().map {
                try $0.decode(column: "id", as: String.self)
            }
        }
    }
}
