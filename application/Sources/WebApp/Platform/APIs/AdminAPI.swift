import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import AsyncHTTPClient
import BlogAdminAPI
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import FeatherAdmin
import WebAdminAPI
import MediaAdminAPI

public struct AdminAPI: Sendable {

    private let apiBaseURL: URL
    private let blogClient: BlogAdminAPI.Client
    private let webClient: WebAdminAPI.Client
    private let mediaClient: MediaAdminAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.apiBaseURL = apiBaseURL

        self.blogClient = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(
                    client: .shared,
                    timeout: .seconds(3)
                )
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
        self.webClient = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(
                    client: .shared,
                    timeout: .seconds(3)
                )
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
        self.mediaClient = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(
                    client: .shared,
                    timeout: .seconds(3)
                )
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
    }

    public func failure(
        statusCode: Int,
        responseBody: HTTPBody?
    ) async throws -> OpenAPIRepositoryError {
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }

    public func withBlogOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(blogClient)
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

    public func withWebOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (WebAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(webClient)
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

    public func withMediaOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (MediaAdminAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(mediaClient)
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

}
