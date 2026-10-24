import FeatherOpenAPI
import FeatherOpenAPIGenerator
import UserOpenAPIGeneratorSupport

extension Credential.Query {

    struct Operation: Credential.Operation {
        var operationId: String? { "authCredentialQuery" }

        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Credential.Query.Schemas.Item(),
                sortFieldKeys: ["userId", "email"],
                filters: Credential.Query.Schemas
                    .Filter()
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
