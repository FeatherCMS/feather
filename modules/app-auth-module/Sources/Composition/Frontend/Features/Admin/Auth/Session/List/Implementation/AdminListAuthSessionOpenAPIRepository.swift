import AuthAdminAPI
import FeatherAdmin
import OpenAPIRuntime

struct AdminListAuthSessionOpenAPIRepository:
    AdminListAuthSessionRepository
{
    let api: AuthAdminAPIClient

    func list(identityID: String) async throws -> AdminListAuthSessionModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentitySessionList(
                path: .init(userIdentityId: identityID),
                headers: .init(accept: [.init(contentType: .json)])
            )
            switch response {
            case .ok(let value):
                let body = try value.body.json
                return .init(
                    identityID: identityID,
                    items: body.items.map {
                        .init(
                            id: $0.id,
                            authenticationType: $0.authenticationType,
                            authenticationReference: $0.authenticationReference,
                            expiresAt: $0.expiresAt,
                            isPersistent: $0.isPersistent,
                            createdAt: $0.createdAt,
                            updatedAt: $0.updatedAt
                        )
                    }
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to view user sessions."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot access user sessions."
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
