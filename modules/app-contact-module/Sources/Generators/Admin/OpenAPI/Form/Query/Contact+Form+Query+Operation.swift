import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

extension Contact.Form.Query {
    struct Operation: Contact.Form.Operation {
        var operationId: String? { "contactFormQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["key", "name"],
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
