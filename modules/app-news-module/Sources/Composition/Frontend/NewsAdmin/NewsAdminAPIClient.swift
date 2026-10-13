import AsyncHTTPClient
public import FeatherAdmin
public import Foundation
public import MediaFrontend
import NIOCore
public import NewsAdminAPI
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public struct NewsAdminAPIClient: Sendable {
    public let client: NewsAdminAPI.Client
    public let apiBaseURL: URL
    public let sessionToken: String?

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.apiBaseURL = apiBaseURL
        self.sessionToken = sessionToken
        client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
        )
    }

    public func mediaAdminAPI() -> MediaAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: sessionToken)
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (NewsAdminAPI.Client) async throws -> T
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
