//
//  TableSeedMigration.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDatabase
import Foundation
import Infrastructure

public struct TableSeedMigration: DatabaseMigration {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let timezone = TimeZone.current.identifier
        try await connection.run(
            query: """
                INSERT INTO account_settings (
                    id,
                    account_id,
                    language,
                    timezone,
                    page_size,
                    created_at,
                    updated_at
                )
                SELECT
                    'account-settings-' || id,
                    id,
                    'en',
                    \(timezone),
                    20,
                    NOW(),
                    NOW()
                FROM user_account
                ON CONFLICT (account_id) DO NOTHING;
                """
        ) { _ in }
    }
}
