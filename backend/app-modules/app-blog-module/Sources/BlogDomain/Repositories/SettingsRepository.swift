//
//  SettingsRepository.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Domain

public protocol SettingsRepository: Repository {
    func get() async throws -> Settings
    func update(
        _ model: Settings
    ) async throws -> Settings
}
