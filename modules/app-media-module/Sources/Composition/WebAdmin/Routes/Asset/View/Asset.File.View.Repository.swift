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
    protocol Interface: Sendable {
        func getAsset(
            id: String
        ) async throws -> Components.Schemas.MediaAssetDetailSchema

        func getAssetWithPreview(
            id: String,
            variants: [String]
        ) async throws -> AdminMediaAsset

        func loadImageAsset(
            assetId: String?,
            variants: [String]
        ) async throws -> AdminMediaAsset?

        func getVariants(
            id: String
        ) async throws -> [Components.Schemas.MediaAssetVariantListItemSchema]
    }
}

extension Asset.File.View {
    enum Repository {}
}
