import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Menu.Query {
    struct Operation: Menu.Operation, BearerProtectedOperation {
        var operationId: String? { "webMenuQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: WebMenuQueryItemSchema(),
                sortFieldKeys: ["id", "key", "name", "createdAt", "updatedAt"],
                filters: SearchFilterSchema()
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
