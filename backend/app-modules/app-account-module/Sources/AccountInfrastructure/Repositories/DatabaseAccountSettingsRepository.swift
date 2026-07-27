//
//  DatabaseAccountSettingsRepository.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountApplication
import AccountDomain
import Application
import FeatherDatabase
import Infrastructure

public struct DatabaseAccountSettingsRepository: AccountSettingsRepository {

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
        return try row.asDomain
    }

    public func create(
        accountID: String
    ) async throws {
        let id = "account-settings-\(accountID)"
        let new = try AccountSettings.create(
            id: id,
            accountID: accountID
        )
        _ = try await AccountSettingsTable(connection: connection)
            .create(
                row: .init(
                    id: new.id,
                    accountID: new.accountID,
                    language: new.language,
                    timezone: new.timezone,
                    pageSize: new.pageSize
                )
            )
    }

    public func update(
        _ model: AccountSettings
    ) async throws -> AccountSettings {
        let row = try await AccountSettingsTable(connection: connection)
            .update(
                id: model.id,
                row: .init(
                    id: model.id,
                    accountID: model.accountID,
                    language: model.language,
                    timezone: model.timezone,
                    pageSize: model.pageSize
                )
            )
        return try row.asDomain
    }

    public func delete(
        id: String
    ) async throws {
        try await AccountSettingsTable(connection: connection).delete(id: id)
    }
}

extension AccountSettingsTable.Row {

    fileprivate var asDomain: AccountSettings {
        get throws {
            .init(
                id: id,
                accountID: accountID,
                language: language,
                timezone: timezone,
                pageSize: pageSize,
                createdAt: createdAt,
                updatedAt: updatedAt
            )
        }
    }
}
