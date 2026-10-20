import FeatherModuleKit
import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserModule

extension Identity.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client
        func load(
            id: String
        ) async throws -> Identity.Detail.RepositoryModel {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.userIdentityGet(
                    path: .init(userIdentityId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok(let okResponse):
                    let identity = try okResponse.body.json
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

    }
}
