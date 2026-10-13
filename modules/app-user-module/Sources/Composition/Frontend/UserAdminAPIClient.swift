import AsyncHTTPClient
public import FeatherAdmin
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
public import UserAdminAPI

public struct UserAdminAPIClient: Sendable {
    public let client: UserAdminAPI.Client

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
        _ operation: @Sendable (UserAdminAPI.Client) async throws -> T
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

public struct UserAPIBuilder: Sendable {
    private let apiBaseURL: URL

    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }

    public func makeUserAdmin(
        _ context: AuthenticatedRequestContext
    ) -> UserAdminAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }

    public func makeUserApp(
        _ context: DefaultRequestContext
    ) -> UserAppAPIClient {
        .init(apiBaseURL: apiBaseURL, sessionToken: context.sessionToken)
    }
}
