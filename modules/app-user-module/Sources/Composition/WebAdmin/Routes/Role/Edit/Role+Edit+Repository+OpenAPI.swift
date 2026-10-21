import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Role.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func load(
            id: String
        ) async throws -> Role.Detail.RepositoryModel {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRoleGet(
                        path: .init(userRoleId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        key: item.key,
                        name: item.name ?? "",
                        notes: item.notes ?? ""
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
            payload: Role.Edit.FormPayload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .userRolePut(
                        path: .init(userRoleId: id),
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(name: payload.name, notes: payload.notes)
                        )
                    )
                switch response {
                case .ok:
                    return
                case .badRequest:
                    throw OpenAPIRepositoryError.failure(
                        .init(
                            statusCode: 400,
                            responseBody: nil,
                            backendError: nil
                        )
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
