import FeatherWebAdmin
import FeatherWebShared
import MediaModule
import MediaWebAdmin
import NewsAdminAPI
import NewsApplication
import NewsModule
import OpenAPIRuntime
import WebAdminAPI

extension Article.List.Repository {
    struct OpenAPI: Interface {
        private struct IndexedItem: Sendable {
            let index: Int
            let item: NewsModule.Article.List.Model.Item
        }

        let api: API.Client

        func search(
            page: Int,
            search: String?,
            status: String?
        ) async throws -> NewsModule.Article.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.newsArticleQuery(
                    .init(
                        body: .json(
                            .init(
                                page: .init(
                                    size: api.accountSettings.pageSize,
                                    number: page
                                ),
                                filters: .init(search: search, status: status)
                            )
                        )
                    )
                )
                switch response {
                case .ok(let value):
                    let body = try value.body.json
                    return .init(
                        items: try await loadItems(body.data.items),
                        total: body.data.total,
                        page: body.query.page.number,
                        pageSize: body.query.page.size
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let code, let value):
                    throw try await api.failure(
                        statusCode: code,
                        responseBody: value.body
                    )
                }
            }
        }

        private func loadItems(
            _ items: [NewsAdminAPI.Components.Schemas.NewsArticleQueryItemSchema]
        ) async throws -> [NewsModule.Article.List.Model.Item] {
            let metadata = try await api.resolveWebMetadata(
                referenceType: "news.article",
                referenceIDs: items.map(\.id)
            )
            let metadataByReferenceID = Dictionary(
                uniqueKeysWithValues: metadata.map { ($0.referenceId, $0) }
            )

            return try await withThrowingTaskGroup(of: IndexedItem.self) {
                group in
                let detailRepository = Article.Detail.Repository.OpenAPI(api: api)
                let mediaRepository = MediaModule.Asset.File.View.Repository
                    .OpenAPI(api: api.mediaAdminAPI())
                for index in items.indices {
                    let item = items[index]
                    group.addTask {
                        let details = try await detailRepository.get(id: item.id)
                        let imageAsset = try await mediaRepository.loadImageAsset(
                            assetId: details.imageAssetId,
                            variants: ["cover", "preview"]
                        )
                        return IndexedItem(
                            index: index,
                            item: .init(
                                id: item.id,
                                title: item.title,
                                imageAsset: imageAsset,
                                metadata: details.metadata.adminValue(
                                    template: "news.article"
                                ),
                                availability: .resolve(
                                    metadataByReferenceID[item.id]?.availability.rawValue
                                )
                            )
                        )
                    }
                }

                var enrichedItems = [NewsModule.Article.List.Model.Item?](
                    repeating: nil,
                    count: items.count
                )
                for try await result in group {
                    enrichedItems[result.index] = result.item
                }
                return enrichedItems.compactMap { $0 }
            }
        }
    }
}
