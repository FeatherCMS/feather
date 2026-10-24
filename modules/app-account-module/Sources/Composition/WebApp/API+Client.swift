public import AccountAppAPI
import AsyncHTTPClient
public import FeatherWebShared
import Foundation
import Hummingbird
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AccountAppAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: DefaultRequestContext
        ) {
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(client: .shared, timeout: .seconds(3))
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AccountAppAPI.Client) async throws -> T
        ) async throws(OpenAPIRepositoryError) -> T {
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

    private struct ClientAPIAuthMiddleware: OpenAPIRuntime.ClientMiddleware {
    let sessionToken: String?

    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next:
            @concurrent @Sendable (HTTPRequest, HTTPBody?, URL) async throws ->
            (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var authenticatedRequest = request
        if let sessionToken {
            authenticatedRequest.headerFields[.authorization] =
                "Bearer \(sessionToken)"
        }
        return try await next(authenticatedRequest, body, baseURL)
    }
    }

    extension HTTPBody {
    fileprivate func collectString() async throws -> String? {
        var buffer = ByteBuffer()
        try await collect(upTo: .max, into: &buffer)
        return buffer.getString(at: 0, length: buffer.readableBytes)
    }
}
