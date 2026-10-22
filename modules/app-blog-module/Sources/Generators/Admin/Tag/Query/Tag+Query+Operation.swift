import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Tag.Query {
    struct Operation: Tag.Operation {
        var operationId: String? { "blogTagQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: BlogTagQueryItemSchema(),
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
