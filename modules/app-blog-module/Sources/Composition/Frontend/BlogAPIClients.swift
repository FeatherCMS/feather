import AsyncHTTPClient
public import BlogAdminAPI
public import BlogAppAPI
public import FeatherAdmin
import FeatherValidation
public import Foundation
import HTML
import Hummingbird
public import MediaFrontend
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebFrontend

public struct BlogAdminAPIClient: Sendable {
    public let client: BlogAdminAPI.Client
    public let sessionToken: String?
    public let apiBaseURL: URL

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
        self.apiBaseURL = apiBaseURL
        self.sessionToken = sessionToken
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
        )
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
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

    public func mediaAdminAPI() -> MediaAdminAPIClient {
        .init(
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
    }
}

public struct BlogAppAPIClient: Sendable {
    public let client: BlogAppAPI.Client
    public let apiBaseURL: URL

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
        self.apiBaseURL = apiBaseURL
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
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

    public func failure(statusCode: Int, responseBody: HTTPBody?) async throws
        -> OpenAPIRepositoryError
    {
        OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: try await responseBody?.collectString()
        )
    }
}

public struct BlogAPIBuilder: Sendable {
    private let apiBaseURL: URL
    public let web: WebAPIBuilder

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
        self.web = .init(apiBaseURL: apiBaseURL)
    }

    public func makeBlogAdmin(
        _ context: AuthenticatedRequestContext
    ) -> BlogAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeBlogApp(
        _ context: DefaultRequestContext
    ) -> BlogAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeBlogApp(
        _ context: AuthenticatedRequestContext
    ) -> BlogAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeWebAdmin(
        _ context: AuthenticatedRequestContext
    ) -> WebAdminAPIClient {
        web.makeWebAdmin(context)
    }
}
