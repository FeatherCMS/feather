import AccountAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime

struct AdminEditAccountInvitationOpenAPIRepository:
    AdminEditAccountInvitationRepository
{
    let api: AccountAdminAPIClient

    init(api: AccountAdminAPIClient) {
        self.api = api
    }

    init() {
        self.api = AccountAdminAPIClient(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: nil
        )
    }

    func get(
        id: String
    ) async throws -> AccountInvitationDetailsModel {
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
                throw OpenAPIRepositoryError.notFound(
                    message: "User invitation not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this user invitation."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot edit user invitations."
                )
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
        payload: AccountInvitationFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .accountInvitationUpdate(
                    path: .init(accountInvitationId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(email: payload.email, roleIds: payload.roleIDs)
                    )
                )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User invitation not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this user invitation."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot edit user invitations."
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
