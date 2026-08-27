import AsyncHTTPClient
import FeatherAdmin
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SystemAdminAPI
import SystemAppAPI

public struct SystemAdminAPIClient: Sendable {
    public let client: SystemAdminAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.client = .init(
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

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (SystemAdminAPI.Client) async throws -> T
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
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }
}

extension SystemAdminAPI.Client {
    private func defaultSearchPage()
        -> SystemAdminAPI.Components.Schemas.SearchPageSchema
    {
        .init(size: 20, number: 1)
    }

    func systemPermissionSearch(
        headers: SystemAdminAPI.Operations.SystemPermissionSearch.Input
            .Headers = .init()
    ) async throws -> SystemAdminAPI.Operations.SystemPermissionSearch.Output {
        try await systemPermissionSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultSearchPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }

    func systemVariableSearch(
        headers: SystemAdminAPI.Operations.SystemVariableSearch.Input.Headers =
            .init()
    ) async throws -> SystemAdminAPI.Operations.SystemVariableSearch.Output {
        try await systemVariableSearch(
            headers: headers,
            body: .json(
                .init(
                    page: defaultSearchPage(),
                    filters: .init(search: nil)
                )
            )
        )
    }
}

extension DefaultRequestContext {
    public func systemManagementAPI() -> SystemAdminAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}

public struct SystemAppAPIClient: Sendable {
    public let client: SystemAppAPI.Client

    public init(
        apiBaseURL: URL,
        sessionToken: String? = nil
    ) {
        self.client = .init(
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

    public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
        _ operation: @Sendable (SystemAppAPI.Client) async throws -> T
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
        let body = try await responseBody?.collectString()
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: body
        )
    }
}

extension DefaultRequestContext {
    public func systemAppAPI() -> SystemAppAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
