public import AnalyticsAdminAPI
import AsyncHTTPClient
public import FeatherWebShared
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AnalyticsAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext
        ) {
            self.client = .init(
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

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (AnalyticsAdminAPI.Client) async throws -> T
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
}
