import AccountAdminAPI
import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import OpenAPIRuntime

extension Invitation.Resend.Repository {

    struct OpenAPI:
        Invitation.Resend.Repository.Interface
    {
        let api: API.Client

        func resend(
            id: String
        ) async throws {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.accountInvitationResend(
                    path: .init(accountInvitationId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
                switch response {
                case .ok:
                    return
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden
                case .notFound:
                    throw OpenAPIRepositoryError.notFound
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
