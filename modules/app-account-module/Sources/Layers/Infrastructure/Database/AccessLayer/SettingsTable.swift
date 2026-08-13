//
//  SettingsTable.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDatabase
import FeatherInfrastructure

import struct Foundation.Date

extension SettingsTable.Row {

    init(from row: DatabaseRow) throws {
        self.id = try row.decode(column: "id", as: String.self)
        self.userId = try row.decode(column: "user_id", as: String.self)
        self.language = try row.decode(column: "language", as: String.self)
        self.timezone = try row.decode(column: "timezone", as: String.self)
        self.pageSize = try row.decode(column: "page_size", as: Int.self)
        self.createdAt = try row.decode(column: "created_at", as: Date.self)
        self.updatedAt = try row.decode(column: "updated_at", as: Date.self)
    }
}

struct SettingsTable {

    struct Row {

        struct Create {
            let id: String
            let userId: String
            let language: String
            let timezone: String
            let pageSize: Int
        }

        struct Update {
            let userId: String
            let language: String
            let timezone: String
            let pageSize: Int
        }

        let id: String
        let userId: String
        let language: String
        let timezone: String
        let pageSize: Int
        let createdAt: Date
        let updatedAt: Date
    }

    let connection: any DatabaseConnection

    func create(
        row: Row.Create
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                INSERT INTO account_settings (
                    id,
                    user_id,
                    language,
                    timezone,
                    page_size,
                    created_at,
                    updated_at
                )
                VALUES (
                    \#(row.id),
                    \#(row.userId),
                    \#(row.language),
                    \#(row.timezone),
                    \#(row.pageSize),
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

    func get(
        userId: String
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                SELECT *
                FROM account_settings
                WHERE user_id = \#(userId)
                LIMIT 1;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func update(
        userId: String,
        row: Row.Update
    ) async throws -> Row {
        try await connection.run(
            query: #"""
                UPDATE account_settings
                SET
                    user_id = \#(row.userId),
                    language = \#(row.language),
                    timezone = \#(row.timezone),
                    page_size = \#(row.pageSize),
                    updated_at = NOW()
                WHERE user_id = \#(userId)
                RETURNING *;
                """#
        ) { sequence in
            guard let row = try await sequence.collect().first else {
                throw RepositoryError.notFound
            }
            return try Row(from: row)
        }
    }

    func delete(
        userId: String
    ) async throws {
        _ = try await connection.run(
            query: #"""
                DELETE FROM account_settings
                WHERE user_id = \#(userId);
                """#
        ) { sequence in
            try await sequence.collect()
        }
    }
}
