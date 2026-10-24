import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View.Repository {
    public struct OpenAPI: Interface, Sendable {
        let api: API.Client

        public init(api: API.Client) {
            self.api = api
        }

        public func getAsset(
            id: String
        ) async throws
            -> MediaAdminAPI.Components.Schemas.MediaAssetDetailSchema
        {
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
            id: String,
            variants: [String] = ["preview"]
        ) async throws -> AdminMediaAsset {
            let asset = try await getAsset(id: id)
            let resolve = try await api.withOpenAPIRepositoryErrorMapping { client in
                let response = try await client.mediaAssetResolve(
                    .init(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(.init(ids: [id], variants: variants))
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
                    throw try await api.failure(
                        statusCode: statusCode,
                        responseBody: response.body
                    )
                }
            }
            let variants =
                resolve
                .first(where: { $0.id == id })?
                .variants
                .map {
                    AdminMediaAssetVariant(
                        key: $0.key,
                        name: $0.name,
                        url: $0.url,
                        extension: $0._extension
                    )
                } ?? []
            return .init(
                schema: asset,
                variants: variants
            )
        }

        public func loadImageAsset(
            assetId: String?,
            variants: [String] = ["preview"]
        ) async throws -> AdminMediaAsset? {
            guard let assetId, !assetId.isEmpty else { return nil }
            return try await getAssetWithPreview(
                id: assetId,
                variants: variants
            )
        }

        func getVariants(
            id: String
        ) async throws -> [Components.Schemas.MediaAssetVariantListItemSchema] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaAssetVariantList(
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
}
