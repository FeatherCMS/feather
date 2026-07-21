//
//  MenuDetail.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application

import struct Foundation.Date

public struct MenuDetail: DTO {
    public let id: String
    public let key: String
    public let name: String
    public let notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        key: String,
        name: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.key = key
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
