import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol AuthMagicLinkOperation: BearerProtectedOperation {
}

extension AuthMagicLinkOperation {
    public var tags: [TagRepresentable] { [AuthMagicLinkTag()] }
}

public protocol AuthMagicLinkIdOperation: AuthMagicLinkOperation {
}

extension AuthMagicLinkIdOperation {
    public var parameters: [ParameterRepresentable] {
        [
            AuthMagicLinkIdParameter().reference()
        ]
    }
}

struct AuthMagicLinkCreateOperation: AuthMagicLinkOperation {
    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkManagementRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: AuthMagicLinkDetailResponse().reference()
        ]
    }
}

struct AuthMagicLinkListOperation: AuthMagicLinkOperation {
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkListResponse().reference()
        ]
    }
}

struct AuthMagicLinkSearchOperation: AuthMagicLinkOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: AuthMagicLinkListItemSchema(),
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

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct AuthMagicLinkDeleteOperation: AuthMagicLinkOperation,
    DeleteOperation
{
}

struct AuthMagicLinkGetOperation: AuthMagicLinkIdOperation {
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}

struct AuthMagicLinkUpdateOperation: AuthMagicLinkIdOperation {
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        AuthMagicLinkPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
