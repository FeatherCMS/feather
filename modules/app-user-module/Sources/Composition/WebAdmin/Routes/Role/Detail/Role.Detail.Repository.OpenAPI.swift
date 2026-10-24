import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Role.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> Role.Detail.Repository.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRoleGet(
                        path: .init(userRoleId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let role = try ok.body.json
                    return .init(
                        id: role.id,
                        key: role.key,
                        name: role.name ?? "",
                        notes: role.notes ?? ""
                    )
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
