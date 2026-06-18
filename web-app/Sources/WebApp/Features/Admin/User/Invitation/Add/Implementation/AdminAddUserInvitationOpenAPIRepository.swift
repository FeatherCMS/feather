import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddUserInvitationOpenAPIRepository: AdminAddUserInvitationRepository
{

    let api: AdminAPI

    func create(
        payload: UserInvitationFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userInvitationCreate(
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
                        "Your account cannot create user invitations."
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
