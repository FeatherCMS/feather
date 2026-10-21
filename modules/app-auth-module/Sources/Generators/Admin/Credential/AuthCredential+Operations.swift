import AuthSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

public protocol AuthCredentialOperation: BearerProtectedOperation {
}

extension AuthCredentialOperation {
    public var tags: [any TagRepresentable] { [AuthCredentialTag()] }
}

public protocol AuthCredentialIdOperation: AuthCredentialOperation {
}

extension AuthCredentialIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            AuthCredentialIdParameter().reference()
        ]
    }
}

struct AuthCredentialCreateOperation: AuthCredentialOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: AuthCredentialDetailResponse().reference()
        ]
    }
}

struct AuthCredentialListOperation: AuthCredentialOperation {
    var responseMap: ResponseMap {
        [
            200: AuthCredentialListResponse().reference()
        ]
    }
}

struct AuthCredentialSearchOperation: AuthCredentialOperation {
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthCredentialListItemSchema(),
            sortFieldKeys: [
                "userId",
                "email",
            ],
            filters: AuthCredentialSearchFilterSchema()
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

struct AuthCredentialRemoveOperation: AuthCredentialOperation,
    DeleteOperation
{
}

struct AuthCredentialGetOperation: AuthCredentialIdOperation {
    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}

struct AuthCredentialUpdateOperation: AuthCredentialIdOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}

struct AuthCredentialPatchOperation: AuthCredentialIdOperation {
    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
