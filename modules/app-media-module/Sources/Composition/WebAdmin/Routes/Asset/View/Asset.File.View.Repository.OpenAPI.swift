import FeatherValidation
import FeatherModuleKit
public import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
public import MediaModule
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
            -> AdminMediaAsset
        {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaAssetGet(
                        path: .init(mediaAssetId: id)
                    )
                switch response {
                case .ok(let ok):
                    let asset = try ok.body.json
                    let title = asset.title?.whitespaceTrimmed
                    return AdminMediaAsset(
                        id: asset.id,
                        name: asset.name,
                        slugPath: asset.slugPath,
                        url: asset.url,
                        extension: asset._extension,
                        contentType: asset.contentType,
                        sizeBytes: asset.sizeBytes,
                        title: title?.isEmpty == false ? title : asset.name,
                        altText: asset.altText,
                        status: asset.status
                    )
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
            return AdminMediaAsset(
                id: asset.id,
                name: asset.name,
                slugPath: asset.slugPath,
                url: asset.url,
                extension: asset.`extension`,
                contentType: asset.contentType,
                sizeBytes: asset.sizeBytes,
                variants: variants,
                title: asset.title,
                altText: asset.altText,
                status: asset.status
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

        public func getVariants(
            id: String
        ) async throws -> [Asset.File.View.Variant] {
            try await api.withOpenAPIRepositoryErrorMapping { client in
                let response =
                    try await client
                    .mediaAssetVariantList(
                        path: .init(mediaAssetId: id)
                    )
                switch response {
                case .ok(let ok):
                    return try ok.body.json.items.map {
                        Asset.File.View.Variant(
                            name: $0.name,
                            fileExtension: $0._extension,
                            url: $0.url
                        )
                    }
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
