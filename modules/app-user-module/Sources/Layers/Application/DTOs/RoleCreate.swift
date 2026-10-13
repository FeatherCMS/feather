//
//  RoleCreate.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

public import FeatherApplication

public struct RoleCreate: DTO {
    public let key: String
    public let name: String?
    public let notes: String?

    public init(
        key: String,
        name: String?,
        notes: String?
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }
}
