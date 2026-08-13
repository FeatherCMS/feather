import AsyncHTTPClient
import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaFrontend
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SGML
import WebFrontend
import WebStandards

public struct BlogAdminAPIClient: Sendable {
    public let client: BlogAdminAPI.Client
    public let sessionToken: String?

    public init(apiBaseURL: URL, sessionToken: String? = nil) {
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
}

public struct BlogAppAPIClient: Sendable {
    public let client: BlogAppAPI.Client

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

extension AppRequestContext {
    public func blogManagementAPI() -> BlogAdminAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    public func blogApplicationAPI() -> BlogAppAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
