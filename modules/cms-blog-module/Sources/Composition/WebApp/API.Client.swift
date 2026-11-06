public import BlogAppAPI
import BlogWebShared
public import FeatherWebShared
public import Foundation
public import OpenAPIRuntime
import WebModuleWebApp

public enum API {
    public struct Client: Sendable {
        public let client: BlogAppAPI.Client
        public let apiBaseURL: URL

        public init(apiBaseURL: URL, sessionToken: String? = nil) {
            self.apiBaseURL = apiBaseURL
            let configuration = BlogAPIClientSupport.configuration(
                sessionToken: sessionToken
            )
            self.client = .init(
                serverURL: apiBaseURL,
                transport: configuration.transport,
                middlewares: configuration.middlewares
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (BlogAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            try await BlogAPIClientSupport.withOpenAPIRepositoryErrorMapping(
                operation,
                using: client
            )
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            try await BlogAPIClientSupport.failure(
                statusCode: statusCode,
                responseBody: responseBody
            )
        }
    }
}
