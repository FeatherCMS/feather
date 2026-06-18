import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveUserAccountSessionOpenAPIRepository:
    AdminRemoveUserAccountSessionRepository
{
    let api: AdminAPI
    private let loadAccountUnauthorizedMessage =
        "Please sign in again to load this user account."
    private let loadSessionsUnauthorizedMessage =
        "Please sign in again to load this user's auth sessions."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this user auth session."

    init(api: AdminAPI) {
        self.api = api
    }

    func get(
        accountId: String,
        sessionId: String
    ) async throws -> AdminRemoveUserAccountSessionModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            async let accountResponse = client.userAccountGet(
                path: .init(userAccountId: accountId),
                headers: .init(accept: [.init(contentType: .json)])
            )
            async let sessionResponse = client.userAccountSessionList(
                path: .init(userAccountId: accountId),
                headers: .init(accept: [.init(contentType: .json)])
            )

            let account = try await accountResponse
            let sessions = try await sessionResponse

            let email: String
            switch account {
            case .ok(let ok):
                email = try ok.body.json.email
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadAccountUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot read user accounts."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }

            let items: [Components.Schemas.UserAuthSessionListItemSchema]
            switch sessions {
            case .ok(let ok):
                items = try ok.body.json.items
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: loadSessionsUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot read user auth sessions."
                )
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }

            guard let session = items.first(where: { $0.id == sessionId })
            else {
                throw OpenAPIRepositoryError.notFound(
                    message: "User account session not found."
                )
            }

            return .init(
                accountId: accountId,
                sessionId: session.id,
                accountEmail: email,
                isPersistent: session.isPersistent,
                expiresAt: session.expiresAt,
                createdAt: session.createdAt,
                updatedAt: session.updatedAt
            )
        }
    }

    func delete(
        accountId: String,
        sessionId: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountSessionDelete(
                path: .init(userAccountId: accountId, sessionId: sessionId)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account session not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: deleteUnauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete user auth sessions."
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
