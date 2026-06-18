import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminEditAuthProfileOpenAPIRepository:
    AdminEditAuthProfileRepository
{
    let api: AdminAPI

    func update(
        id: String,
        payload: AdminEditAuthProfileFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountPatch(
                path: .init(userAccountId: id),
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        email: payload.email,
                        password: payload.password,
                        roleIds: nil
                    )
                )
            )
            switch response {
            case .ok:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: "Please sign in again to edit the profile."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot edit the profile."
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
