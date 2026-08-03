//
//  AccountSettingsQueries.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import Application

public protocol AccountSettingsQueries: Sendable {

    func get(
        accountID: String
    ) async throws -> AccountSettings
}
