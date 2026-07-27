//
//  WriteAccountAndSettings.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 07. 27.

import AccountDomain
import Application
import UserDomain

public struct WriteAccountAndSettings: Scope {
    public let account: any AccountRepository
    public let settings: any AccountSettingsRepository

    public init(
        account: any AccountRepository,
        settings: any AccountSettingsRepository
    ) {
        self.account = account
        self.settings = settings
    }
}
