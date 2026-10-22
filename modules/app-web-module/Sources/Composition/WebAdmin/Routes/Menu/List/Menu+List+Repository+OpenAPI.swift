import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebDomain

extension Menu.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
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

        init(api: API.Client) {
            self.api = api
        }

        func listMenus(
            page: Int,
            search: String?
        ) async throws -> Menu.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .menuQuery(
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

    }
}
