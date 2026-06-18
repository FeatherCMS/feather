import AdminOpenAPI
import Foundation
import Hummingbird

struct AdminRemoveUserAccountOpenAPIRepository: AdminRemoveUserAccountRepository
{
    let api: AdminAPI
    private let unauthorizedMessage =
        "Please sign in again to delete this user account."

    init(api: AdminAPI) {
        self.api = api
    }

    func delete(
        id: String
    ) async throws {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.userAccountDelete(
                path: .init(userAccountId: id)
            )
            switch response {
            case .noContent:
                return
            case .notFound:
                throw OpenAPIRepositoryError.notFound(
                    message: "User account not found."
                )
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot delete user accounts."
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
