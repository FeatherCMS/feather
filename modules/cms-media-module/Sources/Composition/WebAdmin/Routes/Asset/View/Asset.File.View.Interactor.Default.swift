import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View.Interactor {
    struct Default: Interface {
        let repository: any Asset.File.View.Repository.Interface

        func getMediaAsset(
            id: String
        ) async throws -> Asset.File.View.Model {
            async let item = repository.getAsset(id: id)
            async let variants = repository.getVariants(id: id)
            return .init(item: try await item, variants: try await variants)
        }

        func getMediaAssetStatus(
            id: String,
            variants: [String]
        ) async throws -> AdminMediaAsset {
            let asset = try await repository.getAsset(id: id)
            guard !variants.isEmpty, asset.status == "ready" else {
                return asset
            }
            return try await repository.getAssetWithPreview(
                id: id,
                variants: variants
            )
        }
    }
}
