import AsyncHTTPClient
public import ContactAppAPI
import ContactWebShared
public import FeatherWebShared
public import Foundation
import HTTPTypes
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public struct ContactAppAPIClient: Sendable {
    private struct AuthMiddleware: ClientMiddleware {
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
            var authenticatedRequest = request
            if let sessionToken {
                authenticatedRequest.headerFields[.authorization] =
                    "Bearer \(sessionToken)"
            }
            return try await next(authenticatedRequest, body, baseURL)
        }
    }

    public let client: ContactAppAPI.Client

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                AuthMiddleware(sessionToken: sessionToken)
            ]
        )
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (ContactAppAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do { return try await operation(client) }
        catch let error as OpenAPIRepositoryError { throw error }
        catch {
            throw OpenAPIRepositoryError.transport(
                description: String(describing: error)
            )
        }
    }

    public func failure(statusCode: Int, responseBody: HTTPBody?) async throws
        -> OpenAPIRepositoryError
    {
        OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: try await responseBody?.collectString()
        )
    }
}
