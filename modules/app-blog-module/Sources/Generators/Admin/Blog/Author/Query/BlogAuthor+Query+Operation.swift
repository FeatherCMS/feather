import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthor.Query {
    struct Operation: BlogAuthor.Operation {
        var operationId: String? { "blogAuthorQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: BlogAuthorQueryItemSchema(),
                sortFieldKeys: ["id", "key", "name", "createdAt", "updatedAt"],
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
