public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebMenuOperation: BearerProtectedOperation {
}

extension WebMenuOperation {
    public var tags: [any TagRepresentable] { [WebMenuTag()] }
}

public protocol WebMenuIDOperation: WebMenuOperation {
}

extension WebMenuIDOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            WebMenuIdParameter().reference()
        ]
    }
}

struct WebMenuCreateOperation: WebMenuOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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

    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
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
    var requestBody: (any RequestBodyRepresentable)? {
        WebMenuPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuDetailResponse().reference(),
            404: CustomResponse(description: "WebMenu not found"),
        ]
    }
}

struct WebMenuRemoveOperation: WebMenuOperation,
    DeleteOperation
{
}
