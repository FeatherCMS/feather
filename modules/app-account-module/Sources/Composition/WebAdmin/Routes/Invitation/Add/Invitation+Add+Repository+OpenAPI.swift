import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Invitation.Add.Repository {

    struct OpenAPI:
        Invitation.Add.Repository.Interface
    {

        let api: API.Client

        func create(
            payload: Invitation.Form.Payload
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .accountInvitationCreate(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                email: payload.email,
                                roleIds: payload.roleIDs
                            )
                        )
                    )
                switch response {
                case .created:
                    return
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
