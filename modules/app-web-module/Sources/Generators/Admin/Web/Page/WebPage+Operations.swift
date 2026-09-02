import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import WebSharedOpenAPIGenerator

public protocol WebPageOperation: BearerProtectedOperation {
}

extension WebPageOperation {
    public var tags: [TagRepresentable] { [WebPageTag()] }
}

public protocol WebPageIDOperation: WebPageOperation {
}

extension WebPageIDOperation {
    public var parameters: [ParameterRepresentable] {
        [
            WebPageIdParameter().reference()
        ]
    }
}

struct WebPageCreateOperation: WebPageOperation {
    var requestBody: RequestBodyRepresentable? {
        WebPageRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            201: WebPageDetailResponse().reference()
        ]
    }
}

struct WebPageListOperation: WebPageOperation {
    var responseMap: ResponseMap {
        [
            200: WebPageListResponse().reference()
        ]
    }
}

struct WebPageSearchOperation: WebPageOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: WebPageListItemSchema(),
            sortFieldKeys: [
                "id",
                "title",
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

struct WebPageGetOperation: WebPageIDOperation {
    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}

struct WebPageUpdateOperation: WebPageIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebPageUpdateRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}

struct WebPagePatchOperation: WebPageIDOperation {
    var requestBody: RequestBodyRepresentable? {
        WebPagePatchRequestBody().reference()
    }

    var responseMap: ResponseMap {
        [
            200: WebPageDetailResponse().reference(),
            404: CustomResponse(description: "WebPage not found"),
        ]
    }
}

struct WebPageDeleteOperation: WebPageOperation,
    DeleteOperation
{
}
