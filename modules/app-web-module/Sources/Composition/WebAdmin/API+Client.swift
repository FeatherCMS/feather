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
        public let sessionToken: String?
        public let apiBaseURL: URL

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.apiBaseURL = environment.apiBaseURL
            self.sessionToken = requestContext.sessionToken
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
            try await WebAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                client,
                operation: operation
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await WebAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }

        public func mediaAdminAPI() -> MediaAdminAPIClient {
            .init(apiBaseURL: apiBaseURL, sessionToken: sessionToken)
        }
    }
}
