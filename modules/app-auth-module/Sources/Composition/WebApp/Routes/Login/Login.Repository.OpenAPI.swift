import AuthAppAPI
import OpenAPIRuntime

extension Login.Repository {
    struct OpenAPI: Interface {
        let appClient: API.Client

        func login(
            _ command: Login.Command
        ) async throws -> Login.Result {
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
                    return .init(
                        token: payload.token,
                        isPersistent: payload.isPersistent,
                        expiresAt: payload.expiresAt
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
}
