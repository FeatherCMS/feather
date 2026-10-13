//
//  SettingsQueries.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

public import AccountDomain

public protocol SettingsQueries: Sendable {

    func get(
        userId: String
    ) async throws -> Settings
}
