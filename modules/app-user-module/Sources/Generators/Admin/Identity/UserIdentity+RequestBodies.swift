//
//  UserIdentity+RequestBodies.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import OpenAPIKit30

public struct UserIdentityCreateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserIdentityCreateSchema().reference())
        ]
    }

    public init() {}
}

public struct UserIdentityUpdateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserIdentityUpdateSchema().reference())
        ]
    }

    public init() {}
}

public struct UserIdentityPatchRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(UserIdentityPatchSchema().reference())
        ]
    }

    public init() {}
}
