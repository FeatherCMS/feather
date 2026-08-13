import AuthSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol AuthCredentialOperation: BearerProtectedOperation {
}

extension AuthCredentialOperation {
    public var tags: [TagRepresentable] { [AuthCredentialTag()] }
}

public protocol AuthCredentialIdOperation: AuthCredentialOperation {
}

extension AuthCredentialIdOperation {
    public var parameters: [ParameterRepresentable] {
        [
            AuthCredentialIdParameter().reference()
        ]
    }
}

struct AuthCredentialCreateOperation: AuthCredentialOperation {
    var requestBody: RequestBodyRepresentable? {
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

struct AuthCredentialFiltersOperation: AuthCredentialOperation {
    var responseMap: ResponseMap {
        [
            200: AuthCredentialFiltersResponse().reference()
        ]
    }
}

struct AuthCredentialSearchOperation: AuthCredentialOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: AuthCredentialListItemSchema(),
            sortFieldKeys: [
                "userId",
                "email",
            ],
            filters: AuthCredentialSearchFilterSchema()
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

struct AuthCredentialBulkDeleteOperation: AuthCredentialOperation,
    BulkDeleteOperation
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
    var requestBody: RequestBodyRepresentable? {
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
    var requestBody: RequestBodyRepresentable? {
        AuthCredentialPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: AuthCredentialDetailResponse().reference(),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}

struct AuthCredentialDeleteOperation: AuthCredentialIdOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "AuthCredential deleted"),
            404: CustomResponse(description: "AuthCredential not found"),
        ]
    }
}
