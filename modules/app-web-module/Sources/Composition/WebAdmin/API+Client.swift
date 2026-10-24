import AsyncHTTPClient
public import FeatherWebAdmin
public import FeatherWebShared
public import Foundation
public import MediaWebAdmin
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import WebAdminAPI
import WebModuleWebShared

extension API {
    public struct Client: Sendable {
        public let client: WebAdminAPI.Client
        private let requestContext: AuthenticatedRequestContext
        public let apiBaseURL: URL
        private let environment: AppEnvironment

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.environment = environment
            self.apiBaseURL = environment.apiBaseURL
            self.requestContext = requestContext
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (WebAdminAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await APIClientSupport.withOpenAPIRepositoryErrorMapping(
                client,
                operation: operation
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

        public func mediaAdminAPI() -> MediaWebAdmin.API.Client {
            .init(environment: environment, requestContext: requestContext)
        }
    }
}
