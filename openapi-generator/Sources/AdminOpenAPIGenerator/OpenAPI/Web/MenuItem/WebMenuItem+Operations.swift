import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

public protocol WebMenuItemOperation: BearerProtectedOperation {
}

extension WebMenuItemOperation {
    public var tags: [TagRepresentable] { [WebMenuItemTag()] }
}

public protocol WebMenuItemMenuOperation: WebMenuItemOperation {
}

extension WebMenuItemMenuOperation {
    public var parameters: [ParameterRepresentable] {
        [
            WebMenuItemMenuIdParameter().reference()
        ]
    }
}

public protocol WebMenuItemIDOperation: WebMenuItemMenuOperation {
}

extension WebMenuItemIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            WebMenuItemMenuIdParameter().reference(),
            WebMenuItemIdParameter().reference(),
        ]
    }
}

struct WebMenuItemCreateOperation: WebMenuItemMenuOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuItemRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: WebMenuItemDetailResponse().reference()
        ]
    }
}

struct WebMenuItemFiltersOperation: WebMenuItemMenuOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuItemFiltersResponse().reference()
        ]
    }
}

struct WebMenuItemSearchOperation: WebMenuItemMenuOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: WebMenuItemListItemSchema(),
            sortFieldKeys: [
                "id",
                "label",
                "url",
                "priority",
                "permission",
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

struct WebMenuItemGetOperation: WebMenuItemIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}

struct WebMenuItemUpdateOperation: WebMenuItemIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuItemUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}

struct WebMenuItemPatchOperation: WebMenuItemIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebMenuItemPatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebMenuItemDetailResponse().reference(),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}

struct WebMenuItemDeleteOperation: WebMenuItemIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "WebMenuItem deleted"),
            404: CustomResponse(description: "WebMenuItem not found"),
        ]
    }
}
