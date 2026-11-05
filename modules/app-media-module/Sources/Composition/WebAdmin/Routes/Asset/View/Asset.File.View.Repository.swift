public import FeatherWebAdmin
public import MediaModule

extension Asset.File.View.Repository {
    public protocol Interface: Sendable {
        func getAsset(
            id: String
        ) async throws -> AdminMediaAsset

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
        ) async throws -> [Asset.File.View.Variant]
    }
}

extension Asset.File.View {
    public enum Repository {}
}
