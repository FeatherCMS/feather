import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Invitation.Query {
    struct Operation: Invitation.Operation, BearerProtectedOperation {
        var operationId: String? { "accountInvitationQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["id", "email", "token", "expiresAt"],
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
