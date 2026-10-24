import AsyncHTTPClient
public import FeatherWebAdmin
public import FeatherWebShared
public import MediaWebAdmin
import NIOCore
public import NewsAdminAPI
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: NewsAdminAPI.Client
        private let environment: AppEnvironment
        private let requestContext: AuthenticatedRequestContext

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.environment = environment
            self.requestContext = requestContext
            client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func mediaAdminAPI() -> MediaWebAdmin.API.Client {
            .init(
                environment: environment,
                requestContext: requestContext
            )
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (NewsAdminAPI.Client) async throws -> T
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
}
