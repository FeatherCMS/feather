import AppOpenAPI
import Foundation

struct AppLoginUserOpenAPIRepository: AppLoginUserRepository {
    let appClient: ApplicationAPI

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
