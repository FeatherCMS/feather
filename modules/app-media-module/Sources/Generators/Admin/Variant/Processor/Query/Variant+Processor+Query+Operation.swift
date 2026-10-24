import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Variant.Processor.Query {
    struct Operation: Variant.Processor.Operation {
        var operationId: String? { "mediaVariantProcessorQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "id", "name", "matchExtensions", "commandTemplate",
                    "isActive",
                ],
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
                .reference(),
                404: CustomResponse(description: "Media variant not found"),
            ]
        }
    }
}
