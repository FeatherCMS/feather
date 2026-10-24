import MediaAdminAPI
import MediaModule

extension Asset.File.Add.Repository {
    protocol Interface: Sendable {
        func listFolders(
            parentId: String?
        ) async throws -> [Components.Schemas.MediaFolderListItemSchema]

        func createFolder(
            name: String,
            parentId: String?
        ) async throws

        func createAsset(
            payload: Asset.File.Add.Upload.Payload,
            variants: [String]?
        ) async throws -> AdminMediaAsset
    }
}
