//
//  UserAccount+RequestBodies.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import OpenAPIKit30

public struct UserAccountCreateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserAccountCreateSchema().reference())
        ]
    }

    public init() {}
}

public struct UserAccountUpdateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserAccountUpdateSchema().reference())
        ]
    }

    public init() {}
}

public struct UserAccountPatchRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserAccountPatchSchema().reference())
        ]
    }

    public init() {}
}
