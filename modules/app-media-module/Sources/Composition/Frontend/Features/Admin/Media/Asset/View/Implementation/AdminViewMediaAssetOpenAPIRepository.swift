import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AdminViewMediaAssetOpenAPIRepository: Sendable {
    let api: MediaAdminAPIClient

    public init(api: MediaAdminAPIClient) {
        self.api = api
    }

    public func getAsset(
        id: String
    ) async throws -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetGet(
                    path: .init(mediaAssetId: id)
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json
            case .notFound:
                throw OpenAPIRepositoryError.notFound
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }

    public func getAssetWithPreview(
        id: String
    ) async throws -> NewAdminMediaAsset {
        let asset = try await getAsset(id: id)
        let resolve = try await api.resolveAssets(
            ids: [id],
            variants: ["image_preview"]
        )
        let variants =
            resolve
            .first(where: { $0.id == id })?
            .variants
            .map {
                NewAdminMediaAssetVariant(
                    name: $0.name,
                    storageKey: $0.storageKey
                )
            } ?? []
        return .init(
            schema: asset,
            variants: variants
        )
    }

    func getVariants(
        id: String
    ) async throws -> [Components.Schemas.MediaAssetVariantListItemSchema] {
        try await api.withOpenAPIRepositoryErrorMapping { client in
            let response =
                try await client
                .mediaAssetVariantSearch(
                    path: .init(mediaAssetId: id)
                )
            switch response {
            case .ok(let ok):
                return try ok.body.json.items
            case .notFound:
                throw OpenAPIRepositoryError.notFound
            case .unauthorized:
                throw OpenAPIRepositoryError.unauthorized
            case .forbidden:
                throw OpenAPIRepositoryError.forbidden
            case .undocumented(let statusCode, let response):
                throw try await api.failure(
                    statusCode: statusCode,
                    responseBody: response.body
                )
            }
        }
    }
}
