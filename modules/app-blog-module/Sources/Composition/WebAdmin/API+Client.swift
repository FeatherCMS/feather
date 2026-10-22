import AsyncHTTPClient
public import BlogAdminAPI
public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

public enum API {
    public struct Client: Sendable {
        public let client: BlogAdminAPI.Client
        private let mediaClient: MediaAdminAPIClient

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.mediaClient = .init(
                environment: environment,
                requestContext: requestContext
            )
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(client: .shared)
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func mediaAdminAPI() -> MediaAdminAPIClient {
            mediaClient
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (BlogAdminAPI.Client) async throws -> T
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
}
