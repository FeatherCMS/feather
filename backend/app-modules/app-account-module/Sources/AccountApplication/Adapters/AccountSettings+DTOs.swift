//
//  AccountSettings+DTOs.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain

extension AccountSettings {

    public var asDetail: AccountSettingsDetail {
        .init(
            id: id,
            accountID: accountID,
            language: language,
            timezone: timezone,
            pageSize: pageSize,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
