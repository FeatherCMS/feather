public import BlogAppAPI
import BlogWebShared
public import FeatherWebAdmin
public import FeatherWebShared
public import OpenAPIRuntime

extension API.App {
    public struct Client: Sendable {
        public let client: BlogAppAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            let configuration = BlogAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (BlogAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await BlogAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await BlogAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
