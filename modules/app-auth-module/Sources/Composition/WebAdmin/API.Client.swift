public import AuthAdminAPI
import AuthWebShared
public import FeatherWebAdmin
public import FeatherWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AuthAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            let configuration = AuthAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AuthAdminAPI.Client) async throws -> T
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
