//
//  RuleDetail.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import RedirectContracts
import RedirectDomain

import struct Foundation.Date

public struct RuleDetail: DTO {
    public let id: String
    public let source: String
    public let destination: String
    public let statusCode: StatusCode
    public let notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        source: String,
        destination: String,
        statusCode: StatusCode,
        notes: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.source = source
        self.destination = destination
        self.statusCode = statusCode
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
