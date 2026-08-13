//
//  UserIdentity+Parameters.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct UserIdentityIdParameter: PathParameterRepresentable {
    public var name: String { "userIdentityId" }
    public var description: String? { "User identity id" }
    public var schema: any OpenAPISchemaRepresentable {
        UserIdentityIDField().reference()
    }

    public init() {}
}
