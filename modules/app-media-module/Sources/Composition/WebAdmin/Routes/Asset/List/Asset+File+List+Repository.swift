import MediaAdminAPI
import MediaModule

extension Asset.File.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            parentId: String?,
            allowedExtensions: [String]
        ) async throws -> Asset.File.List.Repository.Result

        func listFolders(
            parentId: String?
        ) async throws -> [Components.Schemas.MediaFolderListItemSchema]

        func createFolder(
            name: String,
            parentId: String?
        ) async throws

        func resolveAssets(
            ids: [String],
            variants: [String]?
        ) async throws -> [Components.Schemas.MediaAssetResolveItemSchema]

        func getFolder(
            id: String
        ) async throws -> Components.Schemas.MediaFolderDetailSchema
    }
}
