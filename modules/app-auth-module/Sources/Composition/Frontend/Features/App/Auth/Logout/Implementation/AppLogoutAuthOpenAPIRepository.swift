import AuthAppAPI
import FeatherAdmin
import OpenAPIRuntime

struct AppLogoutAuthOpenAPIRepository: AppLogoutAuthRepository {
    let appClient: AuthAppAPIClient
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
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await appClient.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
