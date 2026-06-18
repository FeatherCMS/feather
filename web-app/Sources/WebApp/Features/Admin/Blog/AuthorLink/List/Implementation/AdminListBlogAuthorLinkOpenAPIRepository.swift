import AdminOpenAPI
import Hummingbird

struct AdminListBlogAuthorLinkOpenAPIRepository:
    AdminListBlogAuthorLinkRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view blog author links."
    private let listForbiddenMessage =
        "Your account cannot access blog author links."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this blog author link."
    private let deleteForbiddenMessage =
        "Your account cannot delete this blog author link."
    private let deleteNotFoundMessage =
        "This blog author link could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listBlogAuthorLinks(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListBlogAuthorLinkModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogAuthorLinkSearch(
                    path: .init(blogAuthorId: menuId),
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
                return .init(
                    items: body.data.items,
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
        menuId: String,
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .blogAuthorLinkDelete(
                    path: .init(blogAuthorId: menuId, blogAuthorLinkId: id)
                )

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
