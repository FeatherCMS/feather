//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17..
//

import Application

public struct RoleCreate: DTO {
    public let name: String
    public let notes: String

    public init(
        name: String,
        notes: String
    ) {
        self.name = name
        self.notes = notes
    }
}
