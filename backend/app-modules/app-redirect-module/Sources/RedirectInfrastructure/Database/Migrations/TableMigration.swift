//
//  TableMigration.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDatabase
import Infrastructure

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
                CREATE TABLE IF NOT EXISTS redirect_rule (
                    id TEXT PRIMARY KEY,
                    source TEXT NOT NULL UNIQUE,
                    destination TEXT NOT NULL,
                    status_code INTEGER NOT NULL,
                    notes TEXT NOT NULL,
                    created_at TIMESTAMPTZ NOT NULL DEFAULT (NOW()),
                    updated_at TIMESTAMPTZ NOT NULL DEFAULT (NOW())
                );
                """#
        ) { _ in }
    }
}
