import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension BlogAuthorLink.Query {
    struct Operation: BlogAuthorLink.Menu.Operation {
        var operationId: String? { "blogAuthorLinkQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: BlogAuthorLinkQueryItemSchema(),
                sortFieldKeys: [
                    "id", "label", "url", "priority", "permission",
                    "createdAt", "updatedAt",
                ],
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
