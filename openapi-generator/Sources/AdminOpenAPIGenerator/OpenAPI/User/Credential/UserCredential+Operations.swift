import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserCredentialOperation: BearerProtectedOperation {
}

extension UserCredentialOperation {
    public var tags: [TagRepresentable] { [UserCredentialTag()] }
}

public protocol UserCredentialIDOperation: UserCredentialOperation {
}

extension UserCredentialIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserCredentialIdParameter().reference()
        ]
    }
}

struct UserCredentialCreateOperation: UserCredentialOperation {
    var requestBody: RequestBodyRepresentable? {
        UserCredentialRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: UserCredentialDetailResponse().reference()
        ]
    }
}

struct UserCredentialListOperation: UserCredentialOperation {
    var responseMap: ResponseMap {
        [
            200: UserCredentialListResponse().reference()
        ]
    }
}

struct UserCredentialFiltersOperation: UserCredentialOperation {
    var responseMap: ResponseMap {
        [
            200: UserCredentialFiltersResponse().reference()
        ]
    }
}

struct UserCredentialSearchOperation: UserCredentialOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: UserCredentialListItemSchema(),
            sortFieldKeys: [
                "accountID",
                "email",
            ],
            filters: UserCredentialSearchFilterSchema()
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

struct UserCredentialBulkDeleteOperation: UserCredentialOperation,
    BulkDeleteOperation
{
}

struct UserCredentialGetOperation: UserCredentialIDOperation {
    var responseMap: ResponseMap {
        [
            200: UserCredentialDetailResponse().reference(),
            404: CustomResponse(description: "UserCredential not found"),
        ]
    }
}

struct UserCredentialUpdateOperation: UserCredentialIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserCredentialUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: UserCredentialDetailResponse().reference(),
            404: CustomResponse(description: "UserCredential not found"),
        ]
    }
}

struct UserCredentialPatchOperation: UserCredentialIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserCredentialPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: UserCredentialDetailResponse().reference(),
            404: CustomResponse(description: "UserCredential not found"),
        ]
    }
}

struct UserCredentialDeleteOperation: UserCredentialIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserCredential deleted"),
            404: CustomResponse(description: "UserCredential not found"),
        ]
    }
}
