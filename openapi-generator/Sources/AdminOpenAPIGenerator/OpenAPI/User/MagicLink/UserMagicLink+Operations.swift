import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol UserMagicLinkOperation: BearerProtectedOperation {
}

extension UserMagicLinkOperation {
    public var tags: [TagRepresentable] { [UserMagicLinkTag()] }
}

public protocol UserMagicLinkIDOperation: UserMagicLinkOperation {
}

extension UserMagicLinkIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            UserMagicLinkIdParameter().reference()
        ]
    }
}

struct UserMagicLinkCreateOperation: UserMagicLinkOperation {
    var requestBody: RequestBodyRepresentable? {
        UserMagicLinkRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            201: UserMagicLinkDetailResponse().reference()
        ]
    }
}

struct UserMagicLinkListOperation: UserMagicLinkOperation {
    var responseMap: ResponseMap {
        [
            200: UserMagicLinkListResponse().reference()
        ]
    }
}

struct UserMagicLinkFiltersOperation: UserMagicLinkOperation {
    var responseMap: ResponseMap {
        [
            200: UserMagicLinkFiltersResponse().reference()
        ]
    }
}

struct UserMagicLinkSearchOperation: UserMagicLinkOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: UserMagicLinkListItemSchema(),
            sortFieldKeys: [
                "id",
                "email",
                "token",
                "expiresAt",
                "isPersistent",
                "isUsed",
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

struct UserMagicLinkBulkDeleteOperation: UserMagicLinkOperation,
    BulkDeleteOperation
{
}

struct UserMagicLinkGetOperation: UserMagicLinkIDOperation {
    var responseMap: ResponseMap {
        [
            200: UserMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "UserMagicLink not found"),
        ]
    }
}

struct UserMagicLinkUpdateOperation: UserMagicLinkIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserMagicLinkUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "UserMagicLink not found"),
        ]
    }
}

struct UserMagicLinkPatchOperation: UserMagicLinkIDOperation {
    var requestBody: RequestBodyRepresentable? {
        UserMagicLinkPatchRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: UserMagicLinkDetailResponse().reference(),
            404: CustomResponse(description: "UserMagicLink not found"),
        ]
    }
}

struct UserMagicLinkDeleteOperation: UserMagicLinkIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "UserMagicLink deleted"),
            404: CustomResponse(description: "UserMagicLink not found"),
        ]
    }
}
