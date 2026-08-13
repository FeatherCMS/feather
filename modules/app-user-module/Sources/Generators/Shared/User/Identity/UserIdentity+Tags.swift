//
//  UserIdentity+Tags.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct UserIdentityTag: TagRepresentable {
    public var name: String = "UserIdentities"
    public var description: String? = "User identities related endpoints."

    public init() {}
}
