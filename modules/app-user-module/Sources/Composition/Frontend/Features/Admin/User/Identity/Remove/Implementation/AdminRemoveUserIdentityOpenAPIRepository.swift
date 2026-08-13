import FeatherAdmin
import Foundation
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI

struct AdminRemoveUserIdentityOpenAPIRepository:
    AdminRemoveUserIdentityRepository
{
    let api: UserAdminAPIClient
    private let unauthorizedMessage =
        "Please sign in again to delete this user identity."

    init(api: UserAdminAPIClient) {
        self.api = api
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userIdentityDelete(
                path: .init(userIdentityId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User identity not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot delete user identities."
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
