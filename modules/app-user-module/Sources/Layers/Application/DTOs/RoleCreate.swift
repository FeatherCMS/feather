//
//  RoleCreate.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 17.
//

import FeatherApplication
import FeatherContracts

public struct RoleCreate: DTO {
    public let id: String
    public let name: String?
    public let notes: String?

    public init(
        id: String,
        name: String?,
        notes: String?
    ) {
        self.id = id
        self.name = name
        self.notes = notes
    }
}
