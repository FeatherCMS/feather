//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application
import struct Foundation.Date

public struct RoleDetail: DTO {
    public let id: String
    public let name: String
    public let notes: String
    public let createdAt: Date
    public let updatedAt: Date

    package init(
        id: String,
        name: String,
        notes: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
