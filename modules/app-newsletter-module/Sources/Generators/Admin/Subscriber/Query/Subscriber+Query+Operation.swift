import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Subscriber.Query {
    struct Operation: Campaign.Operation {
        var operationId: String? { "newsletterSubscriberQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["email"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "campaignKey": Newsletter.Schemas.Key()
                            .reference(required: false),
                        "email": Newsletter.Schemas.Email()
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
