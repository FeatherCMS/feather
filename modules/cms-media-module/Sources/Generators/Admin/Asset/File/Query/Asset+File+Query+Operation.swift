import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.File.Query {
    struct Operation: Asset.File.Operation {
        var operationId: String? { "mediaAssetQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "id", "name", "slugPath", "extension", "sizeBytes",
                    "status", "title", "createdAt", "updatedAt",
                ],
                filters: Schemas.Filters()
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
