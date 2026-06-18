//
//  UserAccount+Responses.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import SharedOpenAPIComponents

struct UserAccountListResponse: JSONResponseRepresentable {
    var description: String = "UserAccount list response"
    var schema = UserAccountListSchema().reference()
}

struct UserAccountFiltersResponse: JSONResponseRepresentable {
    var description: String = "UserAccount filter response"
    var schema = SearchFilterSchema().reference()
}

struct UserAccountSessionListResponse: JSONResponseRepresentable {
    var description: String = "UserAccount session list response"
    var schema = UserAuthSessionListSchema().reference()
}
