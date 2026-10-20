import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Identity.Query {
    struct Operation: Identity.Operation {
        var operationId: String? { "userIdentityQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: UserIdentityListItemSchema(),
                sortFieldKeys: ["id"],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "role": UserRoleNameField().reference(required: false)
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
