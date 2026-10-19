import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Query {

    struct Operation: Variable.Operation, BearerProtectedOperation {
        var operationId: String? { "systemVariableQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Variable.Query.Schemas.Item(),
                sortFieldKeys: ["key", "name", "value", "notes"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "ids": Variable.Query.Schemas.Filter()
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
