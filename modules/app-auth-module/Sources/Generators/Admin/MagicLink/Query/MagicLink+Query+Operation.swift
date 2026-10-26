import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension MagicLink.Query {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "id",
                    "credentialId",
                    "token",
                    "expiresAt",
                    "isPersistent",
                    "isUsed",
                ],
                filters: SearchFilterSchema(
                    additionalProperties: [
                        "userId":
                            Schemas
                            .UserID()
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
