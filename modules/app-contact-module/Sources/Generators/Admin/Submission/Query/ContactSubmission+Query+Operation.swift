import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension ContactSubmission.Query {
    struct Operation: ContactFormOperation, BearerProtectedOperation {
        var operationId: String? { "contactSubmissionQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["createdAt", "formName", "status"],
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
