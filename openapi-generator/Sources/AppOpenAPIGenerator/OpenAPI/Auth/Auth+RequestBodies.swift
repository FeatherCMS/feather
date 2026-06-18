//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 23..
//

import FeatherOpenAPI
import OpenAPIKit30

public struct AuthRegisterRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(AuthRegisterSchema().reference())
        ]
    }

    public init() {}
}
