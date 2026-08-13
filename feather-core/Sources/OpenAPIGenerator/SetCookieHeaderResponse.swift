//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 05..
//

import FeatherOpenAPI
import OpenAPIKit30

public protocol SetCookieHeaderResponse: ResponseRepresentable {}

extension SetCookieHeaderResponse {

    public var headerMap: HeaderMap {
        [
            "Set-Cookie": SetCookieHeader().reference()
        ]
    }
}

public struct SetCookieHeader: HeaderRepresentable {
    //    public var openAPIIdentifier: String { "SetCookieHeader" }

    public var description: String? =
        "Session cookie returned by authentication endpoints."

    public var schema: any OpenAPISchemaRepresentable {
        SetCookieHeaderValueField().reference()
    }

    public init() {}
}

public struct SetCookieHeaderValueField: StringSchemaRepresentable {

    public var example: String? =
        "session_token=abc123; HttpOnly; Path=/; SameSite=Lax"

    public init() {}
}
