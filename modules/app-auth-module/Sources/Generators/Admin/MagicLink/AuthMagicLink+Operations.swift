public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

public protocol AuthMagicLinkOperation: BearerProtectedOperation {
}

extension AuthMagicLinkOperation {
    public var tags: [any TagRepresentable] { [AuthMagicLinkTag()] }
}

public protocol AuthMagicLinkIdOperation: AuthMagicLinkOperation {
}

extension AuthMagicLinkIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            AuthMagicLinkIdParameter().reference()
        ]
    }
}

struct AuthMagicLinkCreateOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkCreate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkManagementRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: AuthMagicLinkDetailResponse().reference()
        ]
    }
}

struct AuthMagicLinkListOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkList" }

    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkListResponse().reference()
        ]
    }
}

struct AuthMagicLinkQueryOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthMagicLinkQueryItemSchema(),
            sortFieldKeys: [
                "id",
                "credentialId",
                "token",
                "expiresAt",
                "isPersistent",
                "isUsed",
            ],
            filters: SearchFilterSchema(
                additionalProperties: [
                    "userId": AuthMagicLinkUserIdField()
                        .reference(required: false)
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

struct AuthMagicLinkRemoveOperation: AuthMagicLinkOperation,
    DeleteOperation
{
    var operationId: String? { "authMagicLinkRemove" }
}

struct AuthMagicLinkGetOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkGet" }

    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}

struct AuthMagicLinkUpdateOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkUpdate" }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}

struct AuthMagicLinkPatchOperation: AuthMagicLinkIdOperation {
    var operationId: String? { "authMagicLinkPatch" }

    var parameters: [any ParameterRepresentable] {
        [
            AuthMagicLinkIdParameter().reference(),
            AuthMagicLinkUpdateMaskParameter().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            400: CustomResponse(description: "Invalid update mask"),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
