import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditAuthMagicLinkOpenAPIRepository:
    AdminEditAuthMagicLinkRepository
{
    let api: AdminAPI

    func get(
        id: String
    ) async throws -> AuthMagicLinkDetailsModel {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userMagicLinkGet(
                    path: .init(userMagicLinkId: id),
                    headers: .init(accept: [.init(contentType: .json)])
                )
            switch response {
            case .ok(let ok):
                let item = try ok.body.json
                return .init(
                    id: item.id,
                    email: item.email,
                    isPersistent: item.isPersistent
                )
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User magic link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to load this user magic link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit user magic links."
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
        payload: AuthMagicLinkFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userMagicLinkUpdate(
                    path: .init(userMagicLinkId: id),
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            email: payload.email,
                            isPersistent: payload.isPersistent
                        )
                    )
                )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User magic link not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to update this user magic link."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your account cannot edit user magic links."
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
