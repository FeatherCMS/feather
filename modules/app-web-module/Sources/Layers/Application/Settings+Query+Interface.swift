//
//  Settings.Query.Interface.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import WebDomain

extension Settings {
    public enum Query {}
}

extension Settings.Query {
    public protocol Interface: Sendable {

        func get() async throws -> SettingsDetail
    }
}
