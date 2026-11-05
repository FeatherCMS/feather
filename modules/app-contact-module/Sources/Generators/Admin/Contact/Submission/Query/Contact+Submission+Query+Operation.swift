import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Contact.Submission.Query {
    struct Operation: Contact.Submission.Operation {
        var operationId: String? { "contactSubmissionQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["createdAt", "formName", "status"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "formKey": Contact.Schemas.FormKey()
                            .reference(
                                required: false
                            )
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
