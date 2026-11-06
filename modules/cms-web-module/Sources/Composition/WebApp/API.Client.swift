public import FeatherWebShared
public import Foundation
public import OpenAPIRuntime
public import WebAppAPI
import WebModuleWebShared

extension API {
    public struct Client: Sendable {
        public let client: WebAppAPI.Client
        public let apiBaseURL: URL

        public init(
            apiBaseURL: URL,
            sessionToken: String? = nil
        ) {
            self.apiBaseURL = apiBaseURL
            let configuration = WebModuleAPIClientSupport.configuration(
                sessionToken: sessionToken
            )
            self.client = .init(
                serverURL: apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (WebAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await WebModuleAPIClientSupport
                .withOpenAPIRepositoryErrorMapping(
                    client,
                    operation: operation
                )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await WebModuleAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }

    }

}
