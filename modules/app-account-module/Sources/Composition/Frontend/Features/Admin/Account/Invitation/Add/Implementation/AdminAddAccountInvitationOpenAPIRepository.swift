import AccountAdminAPI
import FeatherAdmin
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
                    body: .json(
                        .init(email: payload.email, roleIds: payload.roleIDs)
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
