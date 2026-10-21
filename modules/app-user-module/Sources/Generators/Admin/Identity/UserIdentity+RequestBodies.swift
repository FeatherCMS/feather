//
//  UserIdentity+RequestBodies.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

public import FeatherOpenAPI

public struct UserIdentityCreateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(Identity.Post.Schema().reference())
        ]
    }

    public init() {}
}
public struct UserIdentityUpdateRequestBody: RequestBodyRepresentable {

    public var contentMap: ContentMap {
        [
            .json: Content(Identity.Put.Schema().reference())
        ]
    }

    public init() {}
}
