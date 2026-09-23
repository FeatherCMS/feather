import AsyncHTTPClient
public import AuthAdminAPI
import AuthAppAPI
import CSS
public import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
public import Foundation
import HTML
import Hummingbird
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import SGML
import SystemAdminAPI
public import SystemFrontend
import UserAdminAPI
import UserAppAPI
public import UserFrontend
import WebBuilders
import WebComponents

public struct AuthAdminAPIClient: Sendable {
    public let client: AuthAdminAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.client = .init(
            serverURL: apiBaseURL,
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [ClientAPIAuthMiddleware(sessionToken: sessionToken)]
        )
    }

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (AuthAdminAPI.Client) async throws -> T
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

public struct AuthAPIBuilder: Sendable {
    private let apiBaseURL: URL
    let user: UserAPIBuilder
    let system: SystemAPIBuilder

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
        self.user = .init(apiBaseURL: apiBaseURL)
        self.system = .init(apiBaseURL: apiBaseURL)
    }

    public func makeAuthAdmin(
        _ context: AuthenticatedRequestContext
    ) -> AuthAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeAuthApp(
        _ context: DefaultRequestContext
    ) -> AuthAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeAuthApp() -> AuthAppAPIClient {
        .init(apiBaseURL: apiBaseURL)
    }

    func makeUserAdmin(
        _ context: AuthenticatedRequestContext
    ) -> UserAdminAPIClient {
        user.makeUserAdmin(context)
    }

    func makeSystemAdmin(
        _ context: AuthenticatedRequestContext
    ) -> SystemAdminAPIClient {
        system.makeSystemAdmin(context)
    }
}
