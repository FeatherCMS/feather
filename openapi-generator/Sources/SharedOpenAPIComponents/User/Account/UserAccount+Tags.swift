//
//  UserAccount+Tags.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI

public struct UserAccountTag: TagRepresentable {
    public var name: String = "UserAccounts"
    public var description: String? = "User accounts related endpoints."

    public init() {}
}
