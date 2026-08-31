import AccountAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminResendAccountInvitationOpenAPIRepository:
    AdminResendAccountInvitationRepository
{
    let api: AccountAdminAPIClient

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
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to resend this invitation."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot resend invitations."
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User invitation not found."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
