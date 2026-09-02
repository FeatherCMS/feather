import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMenuOperation: BearerProtectedOperation {
}

extension WebMenuOperation {
    public var tags: [TagRepresentable] { [WebMenuTag()] }
}

public protocol WebMenuIDOperation: WebMenuOperation {
}

extension WebMenuIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            WebMenuIdParameter().reference()
        ]
    }
}

struct WebMenuCreateOperation: WebMenuOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: WebMenuDetailResponse().reference()
        ]
    }
}

struct WebMenuListOperation: WebMenuOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuListResponse().reference()
        ]
    }
}

struct WebMenuSearchOperation: WebMenuOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: WebMenuListItemSchema(),
            sortFieldKeys: [
                "id",
                "key",
                "name",
                "createdAt",
                "updatedAt",
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

struct WebMenuGetOperation: WebMenuIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuDetailResponse().reference(),
            404: CustomResponse(description: "WebMenu not found"),
        ]
    }
}

struct WebMenuUpdateOperation: WebMenuIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuDetailResponse().reference(),
            404: CustomResponse(description: "WebMenu not found"),
        ]
    }
}

struct WebMenuPatchOperation: WebMenuIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuDetailResponse().reference(),
            404: CustomResponse(description: "WebMenu not found"),
        ]
    }
}

struct WebMenuDeleteOperation: WebMenuOperation,
    DeleteOperation
{
}
