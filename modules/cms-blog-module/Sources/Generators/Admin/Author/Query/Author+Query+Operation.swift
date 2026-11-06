import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Author.Query {
    struct Operation: Author.Operation {
        var operationId: String? { "blogAuthorQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: ItemSchema(),
                sortFieldKeys: ["id", "key", "name", "createdAt", "updatedAt"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "status": Author.Schemas.Status().reference(required: false)
                    ]
                )
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
