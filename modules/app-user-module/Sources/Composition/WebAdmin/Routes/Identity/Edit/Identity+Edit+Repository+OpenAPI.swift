import FeatherWebAdmin
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Edit.Repository {
    struct OpenAPI:
        Interface
    {
        let api: API.Client
        func load(
            id: String
        ) async throws -> Identity.Edit.Model {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userIdentityGet(
                    path: .init(userIdentityId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let ok):
                    let identity = try ok.body.json
                    return .init(
                        id: identity.id,
                        name: identity.name,
                        status: identity.status.rawValue,
                        roleIds: Array(identity.roleIds ?? [])
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

        func update(
            id: String,
            payload: Identity.Edit.FormPayload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userIdentityPatch(
                    path: .init(userIdentityId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            name: payload.name,
                            status: .init(rawValue: payload.status) ?? .invited,
                            roleIds: payload.roleIds
                        )
                    )
                )
                switch response {
                case .ok:
                    return
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
