import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension ContactField.Query {
    struct Operation: ContactFieldOperation, BearerProtectedOperation {
        var operationId: String? { "contactFieldQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["key", "label", "type", "isRequired"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "form": ContactFormKeyField()
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
