//
//  UserIdentity+Responses.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator

public struct UserIdentityDetailResponse: JSONResponseRepresentable {
    public var description: String = "UserIdentity response"
    public var schema = UserIdentityDetailSchema().reference()

    public init() {}
}
