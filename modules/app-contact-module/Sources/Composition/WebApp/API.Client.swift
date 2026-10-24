public import ContactAppAPI
import ContactWebShared
public import FeatherWebShared
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: ContactAppAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: DefaultRequestContext? = nil
        ) {
            let configuration = ContactAPIClientSupport.configuration(
                sessionToken: requestContext?.sessionToken
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (ContactAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await ContactAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await ContactAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
