import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Post.Query {
    struct Operation: Post.Operation {
        var operationId: String? { "blogPostQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: ItemSchema(),
                sortFieldKeys: ["id", "title", "createdAt", "updatedAt"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "status": Post.Schemas.Status().reference(required: false)
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
