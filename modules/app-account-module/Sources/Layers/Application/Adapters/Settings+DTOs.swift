//
//  Settings+DTOs.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain

extension Settings {

    public var asDetail: SettingsDetail {
        .init(
            userId: userId,
            language: language,
            timezone: timezone,
            pageSize: pageSize,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
