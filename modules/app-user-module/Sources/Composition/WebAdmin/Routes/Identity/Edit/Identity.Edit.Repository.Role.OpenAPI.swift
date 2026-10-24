import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Edit.Repository.Role {
    struct OpenAPI:
        Interface
    {
        let api: API.Client
        func list() async throws -> [Identity.Edit.RoleOption] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userRoleList(
                    query: .init(limit: 100),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok):
                    return try ok.body.json.map {
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
