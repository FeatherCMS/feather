//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol UserIdentityOperation: BearerProtectedOperation {
}

extension UserIdentityOperation {
    public var tags: [any TagRepresentable] { [UserIdentityTag()] }
}

public protocol UserIdentityIDOperation: UserIdentityOperation {

}

extension UserIdentityIDOperation {

    public var parameters: [any ParameterRepresentable] {
        [
            UserIdentityIdParameter().reference()
        ]
    }
}

struct UserIdentityCreateOperation: UserIdentityOperation {
    var summary: String? = "Create user identity"
    var description: String? = "Creates an user identity"

    var requestBody: (any RequestBodyRepresentable)? {
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

struct UserIdentitySearchOperation: UserIdentityOperation {

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: UserIdentityListItemSchema(),
            sortFieldKeys: [
                "id"
            ],
            filters: SearchFilterSchema(
                additionalProperties: [
                    "role": UserRoleNameField().reference(required: false)
                ]
            )
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchRequestQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(
                query: SearchResponseQuerySchema(query: searchRequestQuery)
            )
            .reference()
        ]
    }
}

struct UserIdentityRemoveOperation: UserIdentityOperation,
    DeleteOperation
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

    var requestBody: (any RequestBodyRepresentable)? {
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

    var requestBody: (any RequestBodyRepresentable)? {
        UserIdentityPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: UserIdentityDetailResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}
