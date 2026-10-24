import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension NewsletterIssue.Query {
    struct Operation: NewsletterIssue.Operation {
        var operationId: String? { "newsletterIssueQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "subject", "status", "scheduledAt", "createdAt",
                ],
                filters: SearchFilterSchema(additionalProperties: [:])
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
