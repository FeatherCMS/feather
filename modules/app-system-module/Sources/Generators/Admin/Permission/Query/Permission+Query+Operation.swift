import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Permission.Query {

    struct Operation: Permission.Operation, BearerProtectedOperation {
        var operationId: String? { "systemPermissionQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Permission.Query.Schemas.Item(),
                sortFieldKeys: ["key", "name", "notes"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "ids": Permission.Query.Schemas.Filter()
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
