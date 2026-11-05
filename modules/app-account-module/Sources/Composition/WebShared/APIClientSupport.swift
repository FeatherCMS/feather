import AsyncHTTPClient
public import FeatherWebShared
public import Foundation
public import HTTPTypes
import NIOCore
public import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public enum AccountAPIClientSupport {
    public struct Configuration {
        public let transport: AsyncHTTPClientTransport
        public let middlewares: [AuthMiddleware]
    }

    public static func configuration(
        sessionToken: String?
    ) -> Configuration {
        Configuration(
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                AuthMiddleware(sessionToken: sessionToken)
            ]
        )
    }

    public static func withOpenAPIRepositoryErrorMapping<
        Client: Sendable,
        Result: Sendable
    >(
        _ operation: @Sendable (Client) async throws -> Result,
        using client: Client
    ) async throws(OpenAPIRepositoryError) -> Result {
        do {
            return try await operation(client)
        }
        catch let error as OpenAPIRepositoryError {
            throw error
        }
        catch {
            throw OpenAPIRepositoryError.transport(
                description: String(describing: error)
            )
        }
    }

    public static func failure(
        statusCode: Int,
        responseBody: HTTPBody?
    ) async throws -> OpenAPIRepositoryError {
        var buffer = ByteBuffer()
        try await responseBody?.collect(upTo: .max, into: &buffer)
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: buffer.getString(at: 0, length: buffer.readableBytes)
        )
    }

    public struct AuthMiddleware: ClientMiddleware {
        public let sessionToken: String?

        public init(sessionToken: String?) {
            self.sessionToken = sessionToken
        }

        public func intercept(
            _ request: HTTPRequest,
            body: HTTPBody?,
            baseURL: URL,
            operationID: String,
            next:
                @concurrent @Sendable (
                    HTTPRequest,
                    HTTPBody?,
                    URL
                ) async throws -> (HTTPResponse, HTTPBody?)
        ) async throws -> (HTTPResponse, HTTPBody?) {
            var authenticatedRequest = request
            if let sessionToken {
                authenticatedRequest.headerFields[.authorization] =
                    "Bearer \(sessionToken)"
            }
            return try await next(authenticatedRequest, body, baseURL)
        }
    }
}
