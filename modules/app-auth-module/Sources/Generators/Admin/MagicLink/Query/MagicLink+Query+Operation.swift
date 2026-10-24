import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension MagicLink.Query {

    struct Operation: MagicLink.Operation {
        var operationId: String? { "authMagicLinkQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: MagicLink.Query.Schemas.Item(),
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
                        "userId": MagicLink.Query.Schemas
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
