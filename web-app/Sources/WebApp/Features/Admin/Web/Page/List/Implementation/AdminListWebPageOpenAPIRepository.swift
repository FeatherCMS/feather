import AdminOpenAPI
import Hummingbird

struct AdminListWebPageOpenAPIRepository:
    AdminListWebPageRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view web pages."
    private let listForbiddenMessage =
        "Your account cannot access web pages."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this web page."
    private let deleteForbiddenMessage =
        "Your account cannot delete this web page."
    private let deleteNotFoundMessage =
        "This web page could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listWebPages(
        page: Int,
        search: String?
    ) async throws -> AdminListWebPageModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webPageSearch(
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
        _ items: [Components.Schemas.WebPageListItemSchema]
    ) async throws -> [AdminListWebPageItemModel] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            try await withThrowingTaskGroup(
                of: (Int, AdminListWebPageItemModel).self
            ) { group in
                let repository = AdminListWebPageFormOpenAPIRepository(api: api)
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

                var enrichedItems = [AdminListWebPageItemModel?](
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
                .webPageDelete(path: .init(webPageId: id))

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
