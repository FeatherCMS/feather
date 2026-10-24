public import AnalyticsAppAPI
import AsyncHTTPClient
public import FeatherWebShared
public import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime

extension API {
    public struct Client: Sendable {
        public let client: AnalyticsAppAPI.Client

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
            _ operation: @Sendable (AnalyticsAppAPI.Client) async throws -> T
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
    }
}
