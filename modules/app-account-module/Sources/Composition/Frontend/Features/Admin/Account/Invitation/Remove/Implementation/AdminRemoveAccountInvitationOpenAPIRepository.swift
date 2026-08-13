import AccountAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveAccountInvitationOpenAPIRepository:
    AdminRemoveAccountInvitationRepository
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
                return .init(id: item.id, email: item.email)
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
                        "Your identity cannot access user invitations."
                )
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
            let response =
                try await client
                .accountInvitationDelete(
                    path: .init(accountInvitationId: id)
                )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User invitation not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to delete this user invitation."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot delete user invitations."
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
