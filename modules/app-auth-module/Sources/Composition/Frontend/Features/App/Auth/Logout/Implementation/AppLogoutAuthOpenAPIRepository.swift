import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

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
                throw OpenAPIRepositoryError.unauthorized(
                    message: unauthorizedMessage
                )
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden(
                    message: "Your identity cannot sign out from this session."
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
