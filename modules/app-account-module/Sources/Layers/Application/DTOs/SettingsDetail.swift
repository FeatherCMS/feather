//
//  SettingsDetail.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct SettingsDetail: DTO {

    public let userId: String
    public let language: String
    public let timezone: String
    public let pageSize: Int
    public let createdAt: Date
    public let updatedAt: Date

    public init(
        userId: String,
        language: String,
        timezone: String,
        pageSize: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.userId = userId
        self.language = language
        self.timezone = timezone
        self.pageSize = pageSize
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
