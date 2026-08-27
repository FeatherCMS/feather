import AsyncHTTPClient
import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

public struct AuthAppAPIClient: Sendable {
    public let client: AuthAppAPI.Client

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
        _ operation: @Sendable (AuthAppAPI.Client) async throws -> T
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

extension DefaultRequestContext {
    public func authAppAPI() -> AuthAppAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
