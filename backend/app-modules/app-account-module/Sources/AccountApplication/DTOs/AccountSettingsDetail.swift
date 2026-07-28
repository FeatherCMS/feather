//
//  AccountSettingsDetail.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import Application

import struct Foundation.Date

public struct AccountSettingsDetail: DTO {

    public let id: String
    public let accountID: String
    public let language: String
    public let timezone: String
    public let pageSize: Int
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        id: String,
        accountID: String,
        language: String,
        timezone: String,
        pageSize: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.accountID = accountID
        self.language = language
        self.timezone = timezone
        self.pageSize = pageSize
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
