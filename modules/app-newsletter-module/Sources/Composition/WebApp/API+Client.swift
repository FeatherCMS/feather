import AsyncHTTPClient
import FeatherWebAdmin
public import FeatherWebShared
public import Foundation
import NIOCore
public import NewsletterAppAPI
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public struct NewsletterAppAPIClient: Sendable {
    public let client: NewsletterAppAPI.Client

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
        )
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (NewsletterAppAPI.Client) async throws -> T
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

public struct NewsletterAppAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeNewsletterApp(
        _ context: DefaultRequestContext
    ) -> NewsletterAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
