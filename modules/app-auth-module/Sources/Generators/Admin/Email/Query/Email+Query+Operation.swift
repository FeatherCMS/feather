import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Email.Query {
    struct Operation: Email.Operation {
        var operationId: String? { "authEmailQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["identityId", "email"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "identityId": Email.Schemas.IdentityIDField()
                            .reference(required: false)
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
