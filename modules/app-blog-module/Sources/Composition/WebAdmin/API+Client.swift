import AsyncHTTPClient
public import BlogAdminAPI
import BlogWebShared
public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public enum API {
    public struct Client: Sendable {
        public let client: BlogAdminAPI.Client
        private let mediaClient: MediaWebAdmin.API.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.mediaClient = .init(
                environment: environment,
                requestContext: requestContext
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(client: .shared)
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func mediaAdminAPI() -> MediaWebAdmin.API.Client {
            mediaClient
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await APIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await APIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
