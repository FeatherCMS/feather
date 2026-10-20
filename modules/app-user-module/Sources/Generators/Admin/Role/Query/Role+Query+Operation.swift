import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Role.Query {
    struct Operation: Role.Operation {
        var operationId: String? { "userRoleQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: UserRoleListItemSchema(),
                sortFieldKeys: ["id", "name", "notes"],
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
