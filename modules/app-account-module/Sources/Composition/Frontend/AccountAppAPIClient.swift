public import AccountAppAPI
import AsyncHTTPClient
public import FeatherAdmin
public import Foundation
public import MediaFrontend
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import UserFrontend

public struct AccountAppAPIClient: Sendable {
    public let client: AccountAppAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
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

public struct AccountAPIBuilder: Sendable {
    private let apiBaseURL: URL
    public let media: MediaAPIBuilder
    public let user: UserAPIBuilder

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
        self.media = .init(apiBaseURL: apiBaseURL)
        self.user = .init(apiBaseURL: apiBaseURL)
    }

    public func makeAccountApp(
        _ context: DefaultRequestContext
    ) -> AccountAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeAccountApp(
        _ context: AuthenticatedRequestContext
    ) -> AccountAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeAccountAdmin(
        _ context: AuthenticatedRequestContext
    ) -> AccountAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeMediaAdmin(
        _ context: AuthenticatedRequestContext
    ) -> MediaAdminAPIClient {
        media.makeMediaAdmin(context)
    }

    public func makeUserAdmin(
        _ context: AuthenticatedRequestContext
    ) -> UserAdminAPIClient {
        user.makeUserAdmin(context)
    }
}
