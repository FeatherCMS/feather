//
//  VariableDetail.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct VariableDetail: DTO {
    public let id: String
    public let value: String
    public let name: String?
    public let notes: String?
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        value: String,
        name: String?,
        notes: String?,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.value = value
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
