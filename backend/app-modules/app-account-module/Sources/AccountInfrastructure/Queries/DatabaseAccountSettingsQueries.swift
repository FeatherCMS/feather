//
//  DatabaseAccountSettingsQueries.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountApplication
import AccountDomain
import FeatherDatabase
import Infrastructure

public struct DatabaseAccountSettingsQueries: AccountSettingsQueries {

    public let connection: any DatabaseConnection

    public init(
        connection: any DatabaseConnection
    ) {
        self.connection = connection
    }

    public func get(
        accountID: String
    ) async throws -> AccountSettings {
        let row = try await AccountSettingsTable(connection: connection)
            .get(accountID: accountID)
        return .init(
            id: row.id,
            accountID: row.accountID,
            language: row.language,
            timezone: row.timezone,
            pageSize: row.pageSize,
            createdAt: row.createdAt,
            updatedAt: row.updatedAt
        )
    }
}
