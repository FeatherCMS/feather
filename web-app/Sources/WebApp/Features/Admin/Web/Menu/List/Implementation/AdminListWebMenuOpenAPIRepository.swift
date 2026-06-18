import AdminOpenAPI
import Hummingbird

struct AdminListWebMenuOpenAPIRepository:
    AdminListWebMenuRepository
{
    let api: AdminAPI
    private let listUnauthorizedMessage =
        "Please sign in again to view web menus."
    private let listForbiddenMessage =
        "Your account cannot access web menus."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this web menu."
    private let deleteForbiddenMessage =
        "Your account cannot delete this web menu."
    private let deleteNotFoundMessage =
        "This web menu could not be found."

    init(api: AdminAPI) {
        self.api = api
    }

    func listWebMenus(
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMenuSearch(
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
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMenuDelete(path: .init(webMenuId: id))

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
