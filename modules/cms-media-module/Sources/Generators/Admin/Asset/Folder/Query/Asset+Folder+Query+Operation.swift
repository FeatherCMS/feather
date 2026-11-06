import FeatherOpenAPI
import FeatherOpenAPIGenerator

extension Asset.Folder.Query {
    struct Operation: Asset.Folder.Operation {
        var operationId: String? { "mediaFolderQuery" }
        var searchRequestQuery: SearchRequestQuerySchema {
            .init(
                items: Schemas.Item(),
                sortFieldKeys: [
                    "id", "name", "path", "assetCount", "totalSizeBytes",
                    "createdAt", "updatedAt",
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
