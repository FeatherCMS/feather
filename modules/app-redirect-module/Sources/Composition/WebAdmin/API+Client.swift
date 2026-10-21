import AsyncHTTPClient
import FeatherWebAdmin
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import RedirectAdminAPI

extension API {
    struct Client: Sendable {
        let client: RedirectAdminAPI.Client

        init(
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

        func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (RedirectAdminAPI.Client) async throws -> T
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

        func failure(
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
