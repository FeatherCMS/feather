import AuthAppAPI
import AuthModule
import FeatherWebShared
import OpenAPIRuntime

extension MagicLink.App.Repository {
    struct OpenAPI: Interface {
        let environment: AppEnvironment

        func request(
            email: String,
            isPersistent: Bool,
            context: DefaultRequestContext
        ) async throws {
            let appClient = API.Client(
                environment: environment,
                requestContext: context
            )
            try await appClient.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.authMagicLink(
                    body: .json(
                        .init(email: email, isPersistent: isPersistent)
                    )
                )
                switch response {
                case .noContent:
                    return
                case .undocumented(let statusCode, let response):
                    throw try await appClient.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
        }

        func verify(
            token: String,
            context: DefaultRequestContext
        ) async throws -> MagicLink.App.Result {
            let appClient = API.Client(
                environment: environment,
                requestContext: context
            )
            return try await appClient.withOpenAPIRepositoryErrorMapping {
                client in
                let response = try await client.authMagicLinkVerify(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(token: token))
                )
                switch response {
                case .ok(let ok):
                    let result = try ok.body.json
                    return .init(token: result.token)
                case .unauthorized:
                    throw OpenAPIRepositoryError.unauthorized
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
