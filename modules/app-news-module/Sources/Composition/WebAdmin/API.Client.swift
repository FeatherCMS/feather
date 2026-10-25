public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
public import NewsAdminAPI
import NewsWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: NewsAdminAPI.Client
        private let environment: AppEnvironment
        private let requestContext: AuthenticatedRequestContext

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.environment = environment
            self.requestContext = requestContext
            let configuration = NewsAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func mediaAdminAPI() -> MediaWebAdmin.Client {
            .init(
                environment: environment,
                requestContext: requestContext
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (NewsAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await NewsAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await NewsAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
