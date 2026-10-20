import FeatherWebAdmin
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Add.Repository.Role {
    struct OpenAPI:
        Interface
    {
        let api: API.Client
        func list() async throws -> [Identity.Add.RoleOption] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userRoleQuery(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            page: .init(size: 500, number: 1),
                            filters: .init(search: nil)
                        )
                    )
                )
                switch response {
                case .ok(let ok):
                    return try ok.body.json.data.items.map {
                        .init(id: $0.id, name: $0.name ?? "")
                    }
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
