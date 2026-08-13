import AccountAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime

struct AdminAddAccountInvitationOpenAPIRepository:
    AdminAddAccountInvitationRepository
{

    let api: AccountAdminAPIClient

    func create(
        payload: AccountInvitationFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .accountInvitationCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(email: payload.email))
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this user invitation."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot create user invitations."
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
