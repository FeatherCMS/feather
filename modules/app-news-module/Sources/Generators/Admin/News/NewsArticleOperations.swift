import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

protocol NewsArticleOperation: BearerProtectedOperation {}

extension NewsArticleOperation {
    var tags: [any TagRepresentable] { [NewsArticleTag()] }
}

protocol NewsArticleIDOperation: NewsArticleOperation {}

extension NewsArticleIDOperation {
    var parameters: [any ParameterRepresentable] {
        [NewsArticleIDParameter().reference()]
    }
}

struct NewsArticleCreateOperation: NewsArticleOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: NewsArticleListItemSchema(),
            sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
            filters: SearchFilterSchema()
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

struct NewsArticleGetOperation: NewsArticleIDOperation {
    var responseMap: ResponseMap {
        [
            200: NewsArticleDetailResponse().reference(),
            404: CustomResponse(description: "News article not found"),
        ]
    }
}

struct NewsArticleUpdateOperation: NewsArticleIDOperation {
    var requestBody: (any RequestBodyRepresentable)? {
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
