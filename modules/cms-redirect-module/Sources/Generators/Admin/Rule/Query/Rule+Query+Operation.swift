import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Rule.Query {
    struct Operation: Rule.Operation {
        var operationId: String? { "redirectRuleQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "id", "source", "destination", "statusCode", "notes",
                ],
                filters: Schemas.Filters()
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
