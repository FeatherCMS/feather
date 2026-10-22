import AsyncHTTPClient
public import BlogAppAPI
public import FeatherWebShared
public import Foundation
import Hummingbird
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import WebModuleWebApp

public enum API {
    public struct Client: Sendable {
        public let client: BlogAppAPI.Client
        public let apiBaseURL: URL

        public init(apiBaseURL: URL, sessionToken: String? = nil) {
            self.apiBaseURL = apiBaseURL
            self.client = .init(
                serverURL: apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                ),
                middlewares: [
                    APIAuthMiddleware(sessionToken: sessionToken)
                ]
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (BlogAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
            do { return try await operation(client) }
            catch let error as OpenAPIRepositoryError { throw error }
            catch {
                throw OpenAPIRepositoryError.transport(
                    description: String(describing: error)
                )
            }
        }

        public func failure(
            statusCode: Int,
            responseBody: HTTPBody?
        ) async throws -> OpenAPIRepositoryError {
            OpenAPIRepositoryError.parsedFailure(
                statusCode: statusCode,
                responseBody: try await responseBody?.collectString()
            )
        }
    }
}

private struct APIAuthMiddleware: ClientMiddleware {
    let sessionToken: String?

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next:
            @concurrent @Sendable (HTTPRequest, HTTPBody?, URL) async throws
            -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        if let sessionToken {
            request.headerFields[.authorization] = "Bearer \(sessionToken)"
        }
        return try await next(request, body, baseURL)
    }
}
