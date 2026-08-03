//
//  AccountSettingsRepository.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Domain

public protocol AccountSettingsRepository: Repository {

    func create(
        accountID: String
    ) async throws

    func update(
        _ model: AccountSettings
    ) async throws -> AccountSettings

    func delete(
        id: String
    ) async throws
}
