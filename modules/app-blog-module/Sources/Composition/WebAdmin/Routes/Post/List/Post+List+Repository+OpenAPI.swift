import BlogAdminAPI
import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Post.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func list(page: Int, search: String?) async throws -> Post.List.Model {
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
            _ items: [BlogAdminAPI.Components.Schemas.BlogPostQueryItemSchema]
        ) async throws -> [Post.List.Item] {
            try await withThrowingTaskGroup(of: (Int, Post.List.Item).self) {
                group in
                for (index, item) in items.enumerated() {
                    group.addTask {
                        let details = try await Post.View.Repository
                            .OpenAPI(
                                api: api
                            )
                            .get(id: item.id)
                        return (
                            index,
                            .init(
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
                for try await (index, item) in group {
                    enrichedItems[index] = item
                }
                return enrichedItems.compactMap { $0 }
            }
        }
    }
}
