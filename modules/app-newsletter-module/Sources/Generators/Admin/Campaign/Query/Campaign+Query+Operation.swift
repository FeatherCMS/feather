import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Campaign.Query {
    struct Operation: Campaign.Operation {
        var operationId: String? { "newsletterCampaignQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["key", "name"],
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
