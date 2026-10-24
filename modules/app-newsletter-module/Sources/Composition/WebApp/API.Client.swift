public import FeatherWebShared
public import NewsletterAppAPI
import NewsletterWebShared

extension API {
    public struct Client: Sendable {
        public let client: NewsletterAppAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: DefaultRequestContext
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
            _ operation: @Sendable (NewsletterAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await NewsletterAPIClientSupport
                .withOpenAPIRepositoryErrorMapping(
                    operation,
                    using: client
                )
        }

    }
}
