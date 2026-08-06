//
//  AccountSettingsHooks.swift
//  app-account-module
//

import FeatherDatabase

public enum AccountSettingsHooks {

    public static func createDefaultSettings(
        accountID: String,
        connection: any DatabaseConnection
    ) async throws {
        try await DatabaseAccountSettingsRepository(
            connection: connection
        )
        .create(accountID: accountID)
    }
}
