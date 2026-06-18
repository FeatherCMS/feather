//
//  UserAccount+Parameters.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI

public struct UserAccountIdParameter: PathParameterRepresentable {
    public var name: String { "userAccountId" }
    public var description: String? { "User account id" }
    public var schema: any OpenAPISchemaRepresentable {
        UserAccountIDField().reference()
    }

    public init() {}
}

public struct UserAccountSessionIdParameter: PathParameterRepresentable {
    public var name: String { "sessionId" }
    public var description: String? { "User account session id" }
    public var schema: any OpenAPISchemaRepresentable {
        UserAuthSessionIDField().reference()
    }

    public init() {}
}
