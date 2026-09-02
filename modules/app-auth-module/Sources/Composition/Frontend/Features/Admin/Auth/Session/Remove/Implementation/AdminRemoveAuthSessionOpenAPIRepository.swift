import AuthAdminAPI
import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminRemoveAuthSessionOpenAPIRepository:
    AdminRemoveAuthSessionRepository
{
    let api: AuthAdminAPIClient
    let userAPI: UserAdminAPIClient
    private let loadIdentityUnauthorizedMessage =
        "Please sign in again to load this user identity."
    private let loadSessionsUnauthorizedMessage =
        "Please sign in again to load this user's auth sessions."
    private let deleteUnauthorizedMessage =
        "Please sign in again to delete this user auth session."

    init(
        api: AuthAdminAPIClient,
        userAPI: UserAdminAPIClient
    ) {
        self.api = api
        self.userAPI = userAPI
    }

    func get(
        identityId: String,
        sessionId: String
    ) async throws -> AdminRemoveAuthSessionModel {
        async let identityResponse = userAPI.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.userIdentityGet(
                path: .init(userIdentityId: identityId),
                headers: .init(accept: [.init(contentType: .json)])
            )
        }
        async let sessionResponse = api.withOpenAPIRepositoryErrorMapping {
            client in
            try await client.userIdentitySessionList(
                path: .init(userIdentityId: identityId),
                headers: .init(accept: [.init(contentType: .json)])
            )
        }

        let identity = try await identityResponse
        let sessions = try await sessionResponse

        switch identity {
        case .ok(let ok):
            let _ = try ok.body.json
        case .notFound:
            throw OpenAPIRepositoryError.notFound(
                message: "User identity not found."
            )
        case .unauthorized:
            throw OpenAPIRepositoryError.unauthorized(
                message: loadIdentityUnauthorizedMessage
            )
        case .forbidden:
            throw OpenAPIRepositoryError.forbidden(
                message: "Your identity cannot read user identities."
            )
        case .undocumented(let statusCode, let response):
            throw try await userAPI.failure(
                statusCode: statusCode,
                responseBody: response.body
            )
        }

        let items:
            [AuthAdminAPI.Components.Schemas.UserAuthSessionListItemSchema]
        switch sessions {
        case .ok(let ok):
            items = try ok.body.json.items
        case .notFound:
            throw OpenAPIRepositoryError.notFound(
                message: "User identity not found."
            )
        case .unauthorized:
            throw OpenAPIRepositoryError.unauthorized(
                message: loadSessionsUnauthorizedMessage
            )
        case .forbidden:
            throw OpenAPIRepositoryError.forbidden(
                message: "Your identity cannot read user auth sessions."
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
                message: "User identity session not found."
            )
        }

        return .init(
            identityId: identityId,
            sessionId: session.id,
            identityEmail: identityId,
            isPersistent: session.isPersistent,
            expiresAt: session.expiresAt,
            createdAt: session.createdAt,
            updatedAt: session.updatedAt
        )
    }

    func delete(
        identityId: String,
        sessionId: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            _ = try await client.userIdentitySessionDelete(
                path: .init(userIdentityId: identityId),
                body: .json(
                    .init(ids: [sessionId], results: false, summary: true)
                )
            )
        }
    }
}
