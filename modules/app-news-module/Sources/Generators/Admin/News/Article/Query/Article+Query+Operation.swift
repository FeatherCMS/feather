import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Article.Query {
    struct Operation: Article.Operation {
        var operationId: String? { "newsArticleQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: ItemSchema(),
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
}
