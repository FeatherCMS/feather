import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension NewsletterSubscriber.Query {
    struct Operation: BearerProtectedOperation {
        var operationId: String? { "newsletterSubscriberQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["email"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "campaignKey": NewsletterKeyField()
                            .reference(required: false),
                        "email": NewsletterEmailField()
                            .reference(required: false),
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
