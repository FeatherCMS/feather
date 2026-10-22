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
    var operationId: String? { "authCredentialCreate" }

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
    var operationId: String? { "authCredentialList" }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialListResponse().reference()
        ]
    }
}

struct AuthCredentialQueryOperation: AuthCredentialOperation {
    var operationId: String? { "authCredentialQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthCredentialQueryItemSchema(),
            sortFieldKeys: [
                "userId",
                "email",
            ],
            filters: AuthCredentialQueryFilterSchema()
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
    var operationId: String? { "authCredentialRemove" }
}

struct AuthCredentialGetOperation: AuthCredentialIdOperation {
    var operationId: String? { "authCredentialGet" }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}

struct AuthCredentialUpdateOperation: AuthCredentialIdOperation {
    var operationId: String? { "authCredentialUpdate" }

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
    var operationId: String? { "authCredentialPatch" }

    var parameters: [any ParameterRepresentable] {
        [
            AuthCredentialIdParameter().reference(),
            AuthCredentialUpdateMaskParameter().reference(),
        ]
    }

    var requestBody: (any RequestBodyRepresentable)? {
        AuthCredentialPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            400: CustomResponse(description: "Invalid update mask"),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
