//
//  ReadAccountSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Application

public struct ReadAccountSettings: Scope {

    public let settings: any AccountSettingsQueries

    public init(
        settings: any AccountSettingsQueries
    ) {
        self.settings = settings
    }
}
