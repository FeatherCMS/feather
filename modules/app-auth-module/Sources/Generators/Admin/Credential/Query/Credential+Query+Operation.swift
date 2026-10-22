import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

struct AuthCredentialQueryOperation: AuthCredentialOperation {
    var operationId: String? { "authCredentialQuery" }

    var searchRequestQuery: SearchRequestQuerySchema {
        .init(
            items: AuthCredentialQueryItemSchema(),
            sortFieldKeys: ["userId", "email"],
            filters: AuthCredentialQueryFilterSchema()
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
