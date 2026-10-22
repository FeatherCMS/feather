import AnalyticsSharedOpenAPIGenerator
import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

struct AnalyticsLogSearchOperation: AnalyticsLogOperation {
    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AnalyticsLogQueryItemSchema(),
            sortFieldKeys: [
                "id",
                "accountId",
                "method",
                "source",
                "path",
                "responseCode",
                "ip",
                "browserName",
                "createdAt",
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
