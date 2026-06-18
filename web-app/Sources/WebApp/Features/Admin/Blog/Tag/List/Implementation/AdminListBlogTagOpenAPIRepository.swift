import AdminOpenAPI
import Hummingbird

struct AdminListBlogTagOpenAPIRepository:
    AdminListBlogTagRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view blog tags."
    private let listForbiddenMessage =
        "Your account cannot access blog tags."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this blog tag."
    private let deleteForbiddenMessage =
        "Your account cannot delete this blog tag."
    private let deleteNotFoundMessage =
        "This blog tag could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listBlogTags(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogTagModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogTagSearch(
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
                throw OpenAPIRepositoryError.unauthorized(
                    message: listUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: listForbiddenMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    private func loadItems(
        _ items: [Components.Schemas.BlogTagListItemSchema]
    ) async throws -> [AdminListBlogTagItemModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            try await withThrowingTaskGroup(
                of: (Int, AdminListBlogTagItemModel).self
            ) { group in
                let repository = AdminListBlogTagFormOpenAPIRepository(api: api)
                for (index, item) in items.enumerated() {
                    group.addTask {
                        let details = try await repository.load(id: item.id)
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

                var enrichedItems = [AdminListBlogTagItemModel?](
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

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogTagDelete(path: .init(blogTagId: id))

            switch response {
            case .noContent:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: deleteForbiddenMessage
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: deleteNotFoundMessage
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

}
