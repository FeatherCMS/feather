//
//  TableMigration.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDatabase
import FeatherInfrastructure

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
        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS account_profile (
                    id TEXT PRIMARY KEY,
                    user_id TEXT NOT NULL UNIQUE REFERENCES user_identity(id) ON DELETE CASCADE,
                    first_name TEXT,
                    last_name TEXT,
                    image_url TEXT,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                ALTER TABLE account_profile
                    ALTER COLUMN first_name DROP NOT NULL,
                    ALTER COLUMN last_name DROP NOT NULL,
                    ALTER COLUMN image_url DROP NOT NULL;
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS account_settings (
                    id TEXT PRIMARY KEY,
                    user_id TEXT NOT NULL UNIQUE REFERENCES user_identity(id) ON DELETE CASCADE,
                    language TEXT NOT NULL DEFAULT 'en',
                    timezone TEXT NOT NULL,
                    page_size INT NOT NULL DEFAULT 20,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    CONSTRAINT account_settings_page_size_check
                        CHECK (page_size IN (10, 20, 50, 100))
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"""
                CREATE TABLE IF NOT EXISTS account_invitation (
                    id TEXT PRIMARY KEY,
                    user_id TEXT NOT NULL REFERENCES user_identity(id)
                        ON DELETE CASCADE,
                    email TEXT NOT NULL,
                    token TEXT NOT NULL UNIQUE,
                    role_ids TEXT NOT NULL DEFAULT '[]',
                    expires_at TIMESTAMPTZ NOT NULL,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                );
                """#
        ) { _ in }
        try await connection.run(
            query: #"ALTER TABLE account_invitation ADD COLUMN IF NOT EXISTS role_ids TEXT NOT NULL DEFAULT '[]';"#
        ) { _ in }
    }
}
