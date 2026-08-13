//
//  UserIdentity+Responses.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserSharedOpenAPIGenerator

struct UserIdentitySessionListResponse: JSONResponseRepresentable {
    var description: String = "UserIdentity session list response"
    var schema = UserAuthSessionListSchema().reference()
}
