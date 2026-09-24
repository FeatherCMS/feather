import AsyncHTTPClient
public import ContactAdminAPI
public import ContactAppAPI
public import FeatherAdmin
import FeatherValidation
public import Foundation
import HTML
import Hummingbird
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct ContactAdminAPIClient: Sendable {
    public let client: ContactAdminAPI.Client

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
        _ operation: @Sendable (ContactAdminAPI.Client) async throws -> T
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

public struct ContactAppAPIClient: Sendable {
    public let client: ContactAppAPI.Client

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
        _ operation: @Sendable (ContactAppAPI.Client) async throws -> T
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

public struct ContactAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeContactAdmin(
        _ context: AuthenticatedRequestContext
    ) -> ContactAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeContactApp(
        _ context: DefaultRequestContext
    ) -> ContactAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
