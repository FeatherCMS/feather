import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Invitation.Remove.Repository {

    struct OpenAPI:
        Invitation.Remove.Repository.Interface
    {
        let api: API.Client

        func get(
            id: String
        ) async throws -> Invitation.Detail.Result {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .accountInvitationGet(
                        path: .init(accountInvitationId: id),
                        headers: .init(accept: [.init(contentType: .json)])
                    )
                switch response {
                case .ok(let ok):
                    let item = try ok.body.json
                    return .init(
                        id: item.id,
                        email: item.email,
                        roleIds: item.roleIds
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

        func delete(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                _ = try await client.accountInvitationDelete(
                    body: .json(.init(ids: [id]))
                )
            }
        }
    }
}
