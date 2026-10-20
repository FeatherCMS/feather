import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Job.Query {
    struct Operation: Job.Operation, BearerProtectedOperation {
        var operationId: String? { "systemJobQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Job.Get.Schema(),
                sortFieldKeys: ["queuedAt"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "status": Job.Schemas.Status()
                            .reference(required: false)
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
