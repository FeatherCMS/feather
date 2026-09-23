import AsyncHTTPClient
public import FeatherAdmin
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import SystemAdminAPI
public import SystemAppAPI

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
        if statusCode == 409 {
            return .conflict
        }
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

public struct SystemAPIBuilder: Sendable {
    private let apiBaseURL: URL

    var baseURL: URL { apiBaseURL }

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeSystemAdmin(
        _ context: AuthenticatedRequestContext
    ) -> SystemAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeSystemApp(
        _ context: DefaultRequestContext
    ) -> SystemAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
