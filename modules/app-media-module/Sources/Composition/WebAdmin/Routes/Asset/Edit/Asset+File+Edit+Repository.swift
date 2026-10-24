import MediaAdminAPI
import MediaModule

extension Asset.File.Edit.Repository {
    protocol Interface: Sendable {
        func getAsset(
            id: String
        ) async throws -> Components.Schemas.MediaAssetDetailSchema

        func updateAsset(
            id: String,
            title: String?,
            altText: String?
        ) async throws -> Components.Schemas.MediaAssetDetailSchema
    }
}
