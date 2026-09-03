//
//  TableMigration.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        let queries: [DatabaseQuery] = [
            // MARK: - identity
            #"""
            CREATE TABLE IF NOT EXISTS user_identity (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                status TEXT NOT NULL,
                is_root BOOLEAN NOT NULL DEFAULT FALSE,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - role
            #"""
            CREATE TABLE IF NOT EXISTS user_role (
                id TEXT PRIMARY KEY,
                name TEXT,
                notes TEXT,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
            );
            """#,
            // MARK: - identity role
            #"""
            CREATE TABLE IF NOT EXISTS user_identity_role (
                role_id TEXT NOT NULL,
                identity_id TEXT NOT NULL,
                created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                PRIMARY KEY (role_id, identity_id),
                FOREIGN KEY(role_id) REFERENCES user_role(id) ON DELETE CASCADE,
                FOREIGN KEY(identity_id) REFERENCES user_identity(id) ON DELETE CASCADE
            );
            """#,
            #"CREATE INDEX IF NOT EXISTS user_identity_role_identity_id_idx ON user_identity_role (identity_id);"#,
        ]

        for query in queries {
            try await connection.run(query: query) { _ in }
        }
    }
}
