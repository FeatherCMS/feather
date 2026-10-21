import FeatherOpenAPI
import FeatherOpenAPIGenerator

struct RedirectRuleQueryOperation: RedirectRuleOperation {
    var operationId: String? { "redirectRuleQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: RedirectRuleQueryItemSchema(),
            sortFieldKeys: ["id", "source", "destination", "statusCode", "notes"],
            filters: RedirectRuleFiltersSchema()
        )
    }

    var requestBody: (any RequestBodyRepresentable)? {
        SearchRequestBody(query: searchRequestQuery)
    }

    var responseMap: ResponseMap {
        [
            200: SearchResponse(
                query: SearchResponseQuerySchema(query: searchRequestQuery)
            ).reference()
        ]
    }
}
