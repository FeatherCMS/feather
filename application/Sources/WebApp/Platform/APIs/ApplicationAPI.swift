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
import AuthAppAPI
import BlogAppAPI
import ContactAppAPI
import WebAppAPI
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import FeatherAdmin

public struct ApplicationAPI: Sendable {

    private let apiBaseURL: URL
    private let authClient: AuthAppAPI.Client
    private let blogClient: BlogAppAPI.Client
    private let contactClient: ContactAppAPI.Client
    private let webClient: WebAppAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.apiBaseURL = apiBaseURL

        self.authClient = .init(
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
        self.contactClient = .init(
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
    }

    public func withSessionToken(
        _ sessionToken: String?
    ) -> Self {
        .init(
            apiBaseURL: apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func withAuthOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (AuthAppAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(authClient)
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
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }

    public func withBlogOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (BlogAppAPI.Client) async throws -> T
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

    public func withContactOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (ContactAppAPI.Client) async throws -> T
    ) async throws(OpenAPIRepositoryError) -> T {
        do {
            return try await operation(contactClient)
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
        _ operation: @Sendable (WebAppAPI.Client) async throws -> T
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
}
