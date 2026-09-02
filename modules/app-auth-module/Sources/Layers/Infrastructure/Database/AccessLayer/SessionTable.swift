//
//  SessionTable.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension SessionTable.Row {

    init(
        from row: DatabaseRow
    ) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.token = try row.decode(column: "token", as: String.self)
        self.identityId = try row.decode(
            column: "identity_id",
            as: String.self
        )
        self.authenticationType = try row.decode(
            column: "authentication_type",
            as: String.self
        )
        self.authenticationReference = try row.decode(
            column: "authentication_reference",
            as: String.self
        )
        self.isPersistent = try row.decode(
            column: "is_persistent",
            as: Bool.self
        )
        self.createdAt = try row.decode(
            column: "created_at",
            as: Date.self
        )
        self.updatedAt = try row.decode(
            column: "updated_at",
            as: Date.self
        )
        self.expiresAt = try row.decode(
            column: "expires_at",
            as: Date.self
        )
    }
}

struct SessionTable {

    struct Row {
        struct Create {
            let id: String
            let token: String
            let identityId: String
            let authenticationType: String
            let authenticationReference: String
            let isPersistent: Bool
            let expiresAtInterval: Double
        }

        let id: String
        let token: String
        let identityId: String
        let authenticationType: String
        let authenticationReference: String
        let isPersistent: Bool
        let createdAt: Date
        let updatedAt: Date
        let expiresAt: Date

    }

    let connection: any DatabaseConnection

    func save(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO auth_session (
                    id,
                    token,
                    identity_id,
                    authentication_type,
                    authentication_reference,
                    is_persistent,
                    created_at,
                    updated_at,
                    expires_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.token),
                    \#(row.identityId),
                    \#(row.authenticationType),
                    \#(row.authenticationReference),
                    \#(row.isPersistent),
                    NOW(),
                    NOW(),
                    NOW() + (\#(row.expiresAtInterval) * INTERVAL '1 second')
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

    func list() async throws -> [Row] {
        try await connection.run(
            query: #"""
                SELECT * FROM auth_session ORDER BY id ASC;
                """#
        ) { sequence in
            try await sequence.collect().map { try Row(from: $0) }
        }
    }

    func find(
        id: String
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                SELECT *
                FROM auth_session
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
                FROM auth_session
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

    func update(
        id: String,
        row: Row
    ) async throws -> Row? {
        try await connection.run(
            query: #"""
                UPDATE auth_session
                SET
                    id=\#(row.id),
                    token=\#(row.token),
                    identity_id=\#(row.identityId),
                    authentication_type=\#(row.authenticationType),
                    authentication_reference=\#(row.authenticationReference),
                    is_persistent=\#(row.isPersistent),
                    updated_at=NOW(),
                    expires_at=TO_TIMESTAMP(\#(row.expiresAt.timeIntervalSince1970))
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
                DELETE FROM auth_session
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
