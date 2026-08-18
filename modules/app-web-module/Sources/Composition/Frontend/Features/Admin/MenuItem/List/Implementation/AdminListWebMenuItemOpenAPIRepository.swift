import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI

struct AdminListWebMenuItemOpenAPIRepository:
    AdminListWebMenuItemRepository
{
    let api: WebAdminAPIClient
    private let listUnauthorizedMessage =
        "Please sign in again to view web menu items."
    private let listForbiddenMessage =
        "Your account cannot access web menu items."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this web menu item."
    private let deleteForbiddenMessage =
        "Your account cannot delete this web menu item."
    private let deleteNotFoundMessage =
        "This web menu item could not be found."

    init(api: WebAdminAPIClient) {
        self.api = api
    }

    func listWebMenuItems(
        menuId: String,
        page: Int,
        search: String?
    ) async throws -> AdminListWebMenuItemModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .webMenuItemSearch(
                    path: .init(webMenuId: menuId),
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
                .webMenuItemDelete(
                    path: .init(webMenuId: menuId, webMenuItemId: id)
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

    func move(
        menuId: String,
        itemId: String,
        beforeItemId: String?
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.webMenuItemMove(
                path: .init(webMenuId: menuId, webMenuItemId: itemId),
                body: .json(
                    .init(beforeItemId: beforeItemId ?? "")
                )
            )

            switch response {
            case .noContent:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to move web menu items."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot move web menu items."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "This web menu item could not be found."
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
