import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Post.List.Repository {
    struct OpenAPI: Interface {
        private struct IndexedItem: Sendable {
            let index: Int
            let item: Post.List.Item
        }

        let api: API.Client

        func search(page: Int, search: String?) async throws -> Post.List.Model
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.blogPostQuery(
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
            _ items: [BlogAdminAPI.Components.Schemas.PostQueryItemSchema]
        ) async throws -> [Post.List.Item] {
            try await withThrowingTaskGroup(of: IndexedItem.self) {
                group in
                for index in items.indices {
                    let item = items[index]
                    group.addTask {
                        let details = try await Post.View.Repository
                            .OpenAPI(
                                api: api
                            )
                            .get(id: item.id)
                        return IndexedItem(
                            index: index,
                            item: .init(
                                id: item.id,
                                title: item.title,
                                metadata: details.metadata
                            )
                        )
                    }
                }

                var enrichedItems = [Post.List.Item?](
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
