import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Field.Query {
    struct Operation: Contact.Field.Operation {
        var operationId: String? { "contactFieldQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["key", "label", "type", "isRequired"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "form": Contact.Schemas.FormKey()
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
