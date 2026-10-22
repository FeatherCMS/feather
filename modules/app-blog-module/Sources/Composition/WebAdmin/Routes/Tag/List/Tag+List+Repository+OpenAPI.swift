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
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func query(page: Int, search: String?) async throws -> Tag.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .blogTagQuery(
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
            _ items: [BlogAdminAPI.Components.Schemas.BlogTagQueryItemSchema]
        ) async throws -> [Tag.List.Item] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                try await withThrowingTaskGroup(
                    of: (Int, Tag.List.Item).self
                ) { group in
                    let repository = Tag.Details.Repository.OpenAPI(api: api)
                    for (index, item) in items.enumerated() {
                        group.addTask {
                            let details = try await repository.get(id: item.id)
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

                    var enrichedItems = [Tag.List.Item?](
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

}
