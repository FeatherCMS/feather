import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsArticleOperation: BearerProtectedOperation {}

extension NewsArticleOperation {
    var tags: [TagRepresentable] { [NewsArticleTag()] }
}

protocol NewsArticleIDOperation: NewsArticleOperation {}

extension NewsArticleIDOperation {
    var parameters: [ParameterRepresentable] {
        [NewsArticleIDParameter().reference()]
    }
}

struct NewsArticleCreateOperation: NewsArticleOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsArticleRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [201: NewsArticleDetailResponse().reference()]
    }
}

struct NewsArticleListOperation: NewsArticleOperation {
    var responseMap: ResponseMap {
        [200: NewsArticleListResponse().reference()]
    }
}

struct NewsArticleSearchOperation: NewsArticleOperation {
    var searchQuery: SearchQuerySchema {
        .init(
            items: NewsArticleListItemSchema(),
            sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
            filters: SearchFilterSchema()
        )
    }

    var requestBody: RequestBodyRepresentable? {
        SearchRequestBody(query: searchQuery)
    }

    var responseMap: ResponseMap {
        [200: SearchResponse(query: searchQuery).reference()]
    }
}

struct NewsArticleGetOperation: NewsArticleIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News article not found"),
        ]
    }
}

struct NewsArticleUpdateOperation: NewsArticleIDOperation {
    var requestBody: RequestBodyRepresentable? {
        NewsArticleUpdateRequestBody().reference()
    }
    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News article not found"),
        ]
    }
}

struct NewsArticleRemoveOperation: NewsArticleOperation, DeleteOperation {}
