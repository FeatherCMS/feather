import AsyncHTTPClient
public import FeatherWebShared
import NIOCore
public import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public enum ContactAPIClientSupport {
    public struct Configuration {
        public let transport: AsyncHTTPClientTransport
        public let middlewares: [ClientAPIAuthMiddleware]
    }

    public static func configuration(
        sessionToken: String?
    ) -> Configuration {
        Configuration(
            transport: AsyncHTTPClientTransport(
                configuration: .init(client: .shared, timeout: .seconds(3))
            ),
            middlewares: [
                ClientAPIAuthMiddleware(sessionToken: sessionToken)
            ]
        )
    }

    public static func withOpenAPIRepositoryErrorMapping<
        Client: Sendable,
        Result: Sendable
    >(
        _ operation: @Sendable (Client) async throws -> Result,
        using client: Client
    ) async throws(OpenAPIRepositoryError) -> Result {
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

    public static func failure(
        statusCode: Int,
        responseBody: HTTPBody?
    ) async throws -> OpenAPIRepositoryError {
        OpenAPIRepositoryError.parsedFailure(
            statusCode: statusCode,
            responseBody: try await responseBody?.collectString()
        )
    }
}
