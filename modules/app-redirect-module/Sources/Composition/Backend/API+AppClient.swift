import AsyncHTTPClient
import Foundation
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import RedirectAppAPI

enum API {}

extension API {
    struct AppClient: Sendable {
        let client: RedirectAppAPI.Client

        init(apiBaseURL: URL) {
            self.client = .init(
                serverURL: apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(3)
                    )
                )
            )
        }

        func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (RedirectAppAPI.Client) async throws -> T
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
