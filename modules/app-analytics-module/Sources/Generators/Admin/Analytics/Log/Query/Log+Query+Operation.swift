import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Analytics.Log.Query {
    struct Operation: Analytics.Log.Operation {
        var operationId: String? { "analyticsLogQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: AnalyticsLogQueryItemSchema(),
                sortFieldKeys: [
                    "id", "accountId", "method", "source", "path",
                    "responseCode", "ip", "browserName", "createdAt",
                ],
                filters: AnalyticsLogFilterSchema()
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
