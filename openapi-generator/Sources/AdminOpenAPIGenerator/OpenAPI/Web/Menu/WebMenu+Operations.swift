import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

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

struct WebMenuFiltersOperation: WebMenuOperation {
    var responseMap: ResponseMap {
        [
            200: WebMenuFiltersResponse().reference()
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

struct WebMenuDeleteOperation: WebMenuIDOperation {
    var responseMap: ResponseMap {
        [
            204: CustomResponse(description: "WebMenu deleted"),
            404: CustomResponse(description: "WebMenu not found"),
        ]
    }
}
