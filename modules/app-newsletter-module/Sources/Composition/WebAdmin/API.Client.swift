public import FeatherWebAdmin
public import FeatherWebShared
public import NewsletterAdminAPI
import NewsletterWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: NewsletterAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            let configuration = NewsletterAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (NewsletterAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await NewsletterAPIClientSupport
                .withOpenAPIRepositoryErrorMapping(
                    operation,
                    using: client
                )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            if statusCode == 409 { return .conflict }
            return try await NewsletterAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
