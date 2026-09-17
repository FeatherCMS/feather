import AsyncHTTPClient
import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import NIOCore
import OpenAPIAsyncHTTPClient
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct MediaAdminAPIClient: Sendable {
    public let client: MediaAdminAPI.Client

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

    public func resolveAssets(
        ids: [String],
        variants: [String]? = nil
    ) async throws -> [MediaAdminAPI.Components.Schemas
        .MediaAssetResolveItemSchema]
    {
        guard !ids.isEmpty else { return [] }

        return try await withOpenAPIRepositoryErrorMapping { client in
            let response = try await client.mediaAssetResolve(
                .init(
                    headers: .init(accept: [.init(contentType: .json)]),
                    body: .json(.init(ids: ids, variants: variants))
                )
            )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    public func loadImageAsset(
        assetId: String?
    ) async throws -> NewAdminMediaAsset? {
        guard let assetId, !assetId.isEmpty else { return nil }
        return try await AdminViewMediaAssetOpenAPIRepository(api: self)
            .getAssetWithPreview(id: assetId)
    }
}

extension DefaultRequestContext {
    public func mediaAdminAPI() -> MediaAdminAPIClient {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
