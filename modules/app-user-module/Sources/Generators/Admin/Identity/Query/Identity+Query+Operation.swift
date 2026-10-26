import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Query {
    struct Operation: Identity.Operation {
        var operationId: String? { "userIdentityQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["id"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "role": Role.Schemas.Name().reference(required: false)
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
