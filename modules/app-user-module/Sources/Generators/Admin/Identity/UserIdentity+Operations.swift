//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol UserIdentityOperation: BearerProtectedOperation {
}

extension UserIdentityOperation {
    public var tags: [TagRepresentable] { [UserIdentityTag()] }
}

public protocol UserIdentityIDOperation: UserIdentityOperation {

}

extension UserIdentityIDOperation {

    public var parameters: [ParameterRepresentable] {
        [
            UserIdentityIdParameter().reference()
        ]
    }
}

struct UserIdentityCreateOperation: UserIdentityOperation {
    var summary: String? = "Create user identity"
    var description: String? = "Creates an user identity"

    var requestBody: RequestBodyRepresentable? {
        UserIdentityCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: UserIdentityDetailResponse().reference()
        ]
    }
}

struct UserIdentityListOperation: UserIdentityOperation {

    var responseMap: ResponseMap {
        [
            200: UserIdentityListResponse().reference()
        ]
    }
}

struct UserIdentityFiltersOperation: UserIdentityOperation {

    var responseMap: ResponseMap {
        [
            200: UserIdentityFiltersResponse().reference()
        ]
    }
}

struct UserIdentitySearchOperation: UserIdentityOperation {

    var searchQuery: SearchQuerySchema {
        .init(
            items: UserIdentityListItemSchema(),
            sortFieldKeys: [
                "id"
            ],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct UserIdentityBulkDeleteOperation: UserIdentityOperation,
    BulkDeleteOperation
{

}

struct UserIdentityGetOperation: UserIdentityIDOperation {

    var responseMap: ResponseMap {
        [
            200: UserIdentityDetailResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}

struct UserIdentityUpdateOperation: UserIdentityIDOperation {

    var requestBody: RequestBodyRepresentable? {
        UserIdentityUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserIdentityDetailResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}

struct UserIdentityPatchOperation: UserIdentityIDOperation {

    var requestBody: RequestBodyRepresentable? {
        UserIdentityPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: UserIdentityDetailResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}

struct UserIdentityDeleteOperation: UserIdentityIDOperation {

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserIdentity deleted"),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}
