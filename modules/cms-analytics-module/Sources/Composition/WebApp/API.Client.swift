public import AnalyticsAppAPI
import AnalyticsWebShared
public import FeatherWebShared

extension API {
    public struct Client: Sendable {
        public let client: AnalyticsAppAPI.Client

        public init(
            environment: AppEnvironment,
            sessionToken: String? = nil
        ) {
            let configuration = AnalyticsAPIClientSupport.configuration(
                sessionToken: sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AnalyticsAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await AnalyticsAPIClientSupport
                .withOpenAPIRepositoryErrorMapping(
                    operation,
                    using: client
                )
        }
    }
}
