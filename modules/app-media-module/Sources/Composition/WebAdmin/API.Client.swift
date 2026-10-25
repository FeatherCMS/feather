import AsyncHTTPClient
import FeatherValidation
public import FeatherWebAdmin
public import FeatherWebShared
import HTML
import Hummingbird
public import MediaAdminAPI
import MediaModule
import NIOCore
import OpenAPIAsyncHTTPClient
public import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension API {
    public struct Client: Sendable {
        public let client: MediaAdminAPI.Client

        public init(
            environment: AppEnvironment,
            requestContext: AuthenticatedRequestContext,
            timeoutSeconds: Int = 3
        ) {
            self.client = .init(
                serverURL: environment.apiBaseURL,
                transport: AsyncHTTPClientTransport(
                    configuration: .init(
                        client: .shared,
                        timeout: .seconds(Int64(max(1, timeoutSeconds)))
                    )
                ),
                middlewares: [
                    ClientAPIAuthMiddleware(
                        sessionToken: requestContext.sessionToken
                    )
                ]
            )
        }

        public func loadImageAsset(
            assetId: String?,
            variants: [String] = ["preview"]
        ) async throws -> AdminMediaAsset? {
            try await Asset.File.View.Repository.OpenAPI(api: self)
                .loadImageAsset(assetId: assetId, variants: variants)
        }

        public func withOpenAPIRepositoryErrorMapping<T: Sendable>(
            _ operation: @Sendable (MediaAdminAPI.Client) async throws -> T
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
