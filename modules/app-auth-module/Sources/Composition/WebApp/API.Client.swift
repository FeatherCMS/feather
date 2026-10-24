public import AuthAppAPI
import AuthWebShared
public import FeatherWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AuthAppAPI.Client

        public init(
            environment: AppEnvironment,
            sessionToken: String? = nil
        ) {
            let configuration = AuthAPIClientSupport.configuration(
                sessionToken: sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public init(
            environment: AppEnvironment,
            requestContext: DefaultRequestContext
        ) {
            self.init(
                environment: environment,
                sessionToken: requestContext.sessionToken
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AuthAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await AuthAPIClientSupport.withOpenAPIRepositoryErrorMapping {
                try await operation(client)
            }
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await AuthAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
