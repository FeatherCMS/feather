//
//  UserAccount+Responses.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI

public struct UserAccountDetailResponse: JSONResponseRepresentable {
    public var description: String = "UserAccount response"
    public var schema = UserAccountDetailSchema().reference()

    public init() {}
}
