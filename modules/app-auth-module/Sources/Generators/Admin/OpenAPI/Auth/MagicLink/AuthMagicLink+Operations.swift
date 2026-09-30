import AuthSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

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

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(query: searchQuery).reference()
        ]
    }
}

struct AuthMagicLinkRemoveOperation: AuthMagicLinkOperation,
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
    var requestBody: (any RequestBodyRepresentable)? {
        AuthMagicLinkPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: AuthMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "AuthMagicLink not found"),
        ]
    }
}
