import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct NewsArticleSearchOperation: NewsArticleOperation {
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: NewsArticleQueryItemSchema(),
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
