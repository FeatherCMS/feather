import AppOpenAPI
import Foundation

struct AppLogoutUserOpenAPIRepository: AppLogoutUserRepository {
    let appClient: ApplicationAPI
    private let unauthorizedMessage =
        "Please sign in again to sign out from this session."

    func logout(
        sessionToken: String
    ) async throws {
        try await appClient.withOpenAPIRepositoryErrorMapping {
            client in
            let response = try await client.authLogout()
            switch response {
            case .noContent:
                return
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your account cannot sign out from this session."
                )
            case .undocumented(let statusCode, let response):
                throw try await appClient.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
