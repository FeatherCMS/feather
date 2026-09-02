//
//  UserIdentity+Responses.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserSharedOpenAPIGenerator

struct UserIdentityListResponse: JSONResponseRepresentable {
    var description: String = "UserIdentity list response"
    var schema = UserIdentityListSchema().reference()
}
