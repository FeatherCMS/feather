//
//  SettingsRepository.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherDomain

public protocol SettingsRepository: Repository {

    func get(
        userId: String
    ) async throws -> Settings

    func getOrCreate(
        userId: String
    ) async throws -> Settings

    func create(
        userId: String
    ) async throws

    func update(
        _ model: Settings
    ) async throws -> Settings

    func delete(
        userId: String
    ) async throws
}
