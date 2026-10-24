import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension MenuItem.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        init(api: API.Client) {
            self.api = api
        }

        func search(
            menuId: String,
            page: Int,
            search: String?
        ) async throws -> MenuItem.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuItemQuery(
                    path: .init(menuId: menuId),
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

        func move(
            menuId: String,
            itemId: String,
            beforeItemId: String?
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.menuItemMove(
                    path: .init(menuId: menuId, menuItemId: itemId),
                    body: .json(
                        .init(beforeItemId: beforeItemId ?? "")
                    )
                )

                switch response {
                case .noContent:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
                case .undocumented(let statusCode, let response):
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }
    }
}
