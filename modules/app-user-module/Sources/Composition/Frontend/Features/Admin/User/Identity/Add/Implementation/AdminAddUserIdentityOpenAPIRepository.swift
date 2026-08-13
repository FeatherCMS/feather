import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminAddUserIdentityOpenAPIRepository: AdminAddUserIdentityRepository {
    let api: UserAdminAPIClient

    func create(
        payload: UserIdentityFormPayloadModel
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .userIdentityCreate(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(
                        .init(
                            status: .init(rawValue: payload.status) ?? .invited
                        )
                    )
                )
            switch response {
            case .created:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message:
                        "Please sign in again to create this user identity."
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message:
                        "Your identity cannot create user identities."
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
