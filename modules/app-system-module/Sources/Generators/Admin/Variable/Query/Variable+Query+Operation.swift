import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variable.Query {

    struct Operation: Variable.Operation, BearerProtectedOperation {
        var operationId: String? { "systemVariableQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["key", "name", "value", "notes"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "ids": Schemas.Filter()
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
