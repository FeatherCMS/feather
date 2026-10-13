//
//  SettingsQueries.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public protocol SettingsQueries: Sendable {

    func get() async throws -> SettingsDetail
}
