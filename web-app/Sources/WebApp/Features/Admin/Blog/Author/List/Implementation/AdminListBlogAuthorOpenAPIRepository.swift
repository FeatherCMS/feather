import AdminOpenAPI
import Hummingbird

struct AdminListBlogAuthorOpenAPIRepository:
    AdminListBlogAuthorRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view blog authors."
    private let listForbiddenMessage =
        "Your account cannot access blog authors."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this blog author."
    private let deleteForbiddenMessage =
        "Your account cannot delete this blog author."
    private let deleteNotFoundMessage =
        "This blog author could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listBlogAuthors(
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogAuthorSearch(
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

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogAuthorDelete(path: .init(blogAuthorId: id))

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

    private func loadItems(
        _ items: [Components.Schemas.BlogAuthorListItemSchema]
    ) async throws -> [AdminListBlogAuthorItemModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            try await withThrowingTaskGroup(
                of: (Int, AdminListBlogAuthorItemModel).self
            ) { group in
                let repository = AdminListBlogAuthorFormOpenAPIRepository(
                    api: api
                )
                for (index, item) in items.enumerated() {
                    group.addTask {
                        let details = try await repository.load(id: item.id)
                        return (
                            index,
                            AdminListBlogAuthorItemModel(
                                id: item.id,
                                name: item.name,
                                profileImageAssetId: item.profileImageAssetId,
                                profileImage: details.profileImage,
                                metadata: details.metadata
                            )
                        )
                    }
                }

                var enrichedItems = [AdminListBlogAuthorItemModel?](
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
