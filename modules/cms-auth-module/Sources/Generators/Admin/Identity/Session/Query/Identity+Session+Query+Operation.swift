import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Identity.Session.Query {
    struct Operation: Identity.IdentifiableOperation {
        var operationId: String? { "userIdentitySessionQuery" }

        private var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["id", "createdAt"],
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
