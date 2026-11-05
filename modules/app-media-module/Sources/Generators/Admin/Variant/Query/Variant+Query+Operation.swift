import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Query {
    struct Operation: Variant.Operation {
        var operationId: String? { "mediaVariantQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: ["id", "key", "name", "isRequired", "isActive"],
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
