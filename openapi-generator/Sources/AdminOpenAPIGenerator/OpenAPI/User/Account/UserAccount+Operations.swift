//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserAccountOperation: BearerProtectedOperation {
}

extension UserAccountOperation {
    public var tags: [TagRepresentable] { [UserAccountTag()] }
}

public protocol UserAccountIDOperation: UserAccountOperation {

}

extension UserAccountIDOperation {

    public var parameters: [ParameterRepresentable] {
        [
            UserAccountIdParameter().reference()
        ]
    }
}

public protocol UserAccountSessionOperation: UserAccountOperation {}

extension UserAccountSessionOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserAccountIdParameter().reference()
        ]
    }
}

public protocol UserAccountSessionIDOperation: UserAccountSessionOperation {}

extension UserAccountSessionIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserAccountIdParameter().reference(),
            UserAccountSessionIdParameter().reference(),
        ]
    }
}

struct UserAccountCreateOperation: UserAccountOperation {
    var summary: String? = "Create user account"
    var description: String? = "Creates an user account"

    var requestBody: RequestBodyRepresentable? {
        UserAccountCreateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: UserAccountDetailResponse().reference()
        ]
    }
}

struct UserAccountListOperation: UserAccountOperation {

    var responseMap: ResponseMap {
        [
            200: UserAccountListResponse().reference()
        ]
    }
}

struct UserAccountFiltersOperation: UserAccountOperation {

    var responseMap: ResponseMap {
        [
            200: UserAccountFiltersResponse().reference()
        ]
    }
}

struct UserAccountSearchOperation: UserAccountOperation {

    var searchQuery: SearchQuerySchema {
        .init(
            items: UserAccountListItemSchema(),
            sortFieldKeys: [
                "id",
                "email",
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

struct UserAccountBulkDeleteOperation: UserAccountOperation, BulkDeleteOperation
{

}

struct UserAccountGetOperation: UserAccountIDOperation {

    var responseMap: ResponseMap {
        [
            200: UserAccountDetailResponse().reference(),
            404: CustomResponse(description: "UserAccount not found"),
        ]
    }
}

struct UserAccountUpdateOperation: UserAccountIDOperation {

    var requestBody: RequestBodyRepresentable? {
        UserAccountUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserAccountDetailResponse().reference(),
            404: CustomResponse(description: "UserAccount not found"),
        ]
    }
}

struct UserAccountPatchOperation: UserAccountIDOperation {

    var requestBody: RequestBodyRepresentable? {
        UserAccountPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: UserAccountDetailResponse().reference(),
            404: CustomResponse(description: "UserAccount not found"),
        ]
    }
}

struct UserAccountDeleteOperation: UserAccountIDOperation {

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserAccount deleted"),
            404: CustomResponse(description: "UserAccount not found"),
        ]
    }
}

struct UserAccountSessionListOperation: UserAccountSessionOperation {

    var responseMap: ResponseMap {
        [
            200: UserAccountSessionListResponse().reference(),
            404: CustomResponse(description: "UserAccount not found"),
        ]
    }
}

struct UserAccountSessionDeleteOperation: UserAccountSessionIDOperation {

    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserAccount session deleted"),
            404: CustomResponse(
                description: "UserAccount session not found"
            ),
        ]
    }
}
