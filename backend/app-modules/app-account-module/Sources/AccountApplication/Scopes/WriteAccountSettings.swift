//
//  WriteAccountSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import Application

public struct WriteAccountSettings: Scope {

    public let queries: any AccountSettingsQueries
    public let settings: any AccountSettingsRepository

    public init(
        queries: any AccountSettingsQueries,
        settings: any AccountSettingsRepository
    ) {
        self.queries = queries
        self.settings = settings
    }
}
