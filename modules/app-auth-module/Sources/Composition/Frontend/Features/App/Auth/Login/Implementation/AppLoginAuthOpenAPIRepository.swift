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

struct AppLoginAuthOpenAPIRepository: AppLoginAuthRepository {
    let appClient: AuthAppAPIClient

    func login(
        _ command: LoginCommandModel
    ) async throws -> LoginResultModel {
        try await appClient.withOpenAPIRepositoryErrorMapping {
            client in
            let response = try await client.authLogin(
                headers: .init(accept: [.init(contentType: .json)]),
                body: .json(
                    .init(
                        email: command.email,
                        password: command.password,
                        isPersistent: command.isPersistent
                    )
                )
            )

            switch response {
            case .ok(let ok):
                let payload = try ok.body.json
                return .init(token: payload.token)
            case .undocumented(let statusCode, let response):
                throw try await appClient.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
