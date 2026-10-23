import AsyncHTTPClient
public import ContactAdminAPI
import ContactWebShared
import FeatherWebAdmin
public import FeatherWebShared
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

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
        if statusCode == 409 {
            return .conflict
        }
        return OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: try await responseBody?.collectString()
        )
    }
}
