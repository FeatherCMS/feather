import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthMagicLinkQueryOperation: AuthMagicLinkOperation {
    var operationId: String? { "authMagicLinkQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthMagicLinkQueryItemSchema(),
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
                    "userId": AuthMagicLinkUserIdField()
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
