import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import SystemAdminAPI
import SystemModule

extension Permission.List.Repository {
    struct OpenAPI:
        Permission.List.Repository.Interface
    {
        let api: API.Client
        private let listUnauthorizedMessage =
            "Please sign in again to view system permissions."
        private let listForbiddenMessage =
            "Your account cannot access system permissions."

        init(api: API.Client) {
            self.api = api
        }

        func listSystemPermissions(
            page: Int,
            search: String?
        ) async throws -> Permission.List.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .systemPermissionQuery(
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
                        items: body.data.items.map { item in
                            .init(
                                id: item.id,
                                key: item.key,
                                name: item.name,
                                notes: item.notes
                            )
                        },
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
