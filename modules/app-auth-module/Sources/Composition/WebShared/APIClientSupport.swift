import AsyncHTTPClient
public import FeatherWebShared
public import Foundation
public import Hummingbird
import NIOCore
public import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public enum AuthAPIClientSupport {
    public struct Configuration {
        public let transport: AsyncHTTPClientTransport
        public let middlewares: [AuthAPIClientAuthMiddleware]
    }

    public static func configuration(
        sessionToken: String?
    ) -> Configuration {
        Configuration(
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                AuthAPIClientAuthMiddleware(sessionToken: sessionToken)
            ]
        )
    }

    public static func withOpenAPIRepositoryErrorMapping<Value: Sendable>(
        _ operation: @Sendable () async throws -> Value
    ) async throws(OpenAPIRepositoryError) -> Value {
        do { return try await operation() }
        catch let error as OpenAPIRepositoryError { throw error }
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
    }

    public struct AuthAPIClientAuthMiddleware: ClientMiddleware {
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
        var request = request
        if let sessionToken {
            request.headerFields[.authorization] = "Bearer \(sessionToken)"
        }
        return try await next(request, body, baseURL)
    }
}
