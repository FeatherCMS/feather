import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminAddAuthMagicLinkOpenAPIRepository:
    AdminAddAuthMagicLinkRepository
{
    let api: AdminAPI

    func create(
        payload: AuthMagicLinkFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userMagicLinkCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            email: payload.email,
                            isPersistent: payload.isPersistent
                        )
                    )
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this user magic link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot create user magic links."
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
