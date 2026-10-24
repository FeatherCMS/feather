import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Author.List.Repository {
    struct OpenAPI: Interface {
        private struct IndexedItem: Sendable {
            let index: Int
            let item: Author.List.Item
        }

        let api: API.Client

        func list(
            page: Int,
            search: String?
        ) async throws -> Author.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .blogAuthorQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: 20, number: page),
                                filters: .init(search: search)
                            )
                        )
                    )

                switch response {
                case .ok(let okResponse):
                    let body = try okResponse.body.json
                    let items = try await loadItems(body.data.items)
                    return .init(
                        items: items,
                        total: body.data.total,
                        page: body.query.page.number,
                        pageSize: body.query.page.size
                    )
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        private func loadItems(
            _ items: [BlogAdminAPI.Components.Schemas.AuthorQueryItemSchema]
        ) async throws -> [Author.List.Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                try await withThrowingTaskGroup(of: IndexedItem.self) { group in
                    let repository = Author.View.Repository.OpenAPI(api: api)
                    for (index, item) in items.enumerated() {
                        group.addTask {
                            let details = try await repository.get(id: item.id)
                            return IndexedItem(
                                index: index,
                                item: Author.List.Item(
                                    id: item.id,
                                    name: item.name,
                                    profileImageAssetId: item
                                        .profileImageAssetId,
                                    profileImage: details.profileImage,
                                    metadata: details.metadata
                                )
                            )
                        }
                    }

                    var enrichedItems = [Author.List.Item?](
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

}
