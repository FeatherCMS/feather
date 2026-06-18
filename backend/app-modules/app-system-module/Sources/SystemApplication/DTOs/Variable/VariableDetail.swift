//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import struct Foundation.Date
import Application

public struct VariableDetail: DTO {
    public let id: String
    public let name: String
    public let value: String
    public let notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        value: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
