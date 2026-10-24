public import AnalyticsAdminAPI
import AnalyticsWebShared
public import FeatherWebAdmin
public import FeatherWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AnalyticsAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            let configuration = AnalyticsAPIClientSupport.configuration(
                sessionToken: requestContext.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AnalyticsAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await AnalyticsAPIClientSupport
                .withOpenAPIRepositoryErrorMapping(
                    operation,
                    using: client
                )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await AnalyticsAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
