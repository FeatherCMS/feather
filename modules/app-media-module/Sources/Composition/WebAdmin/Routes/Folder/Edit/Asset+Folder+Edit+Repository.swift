import MediaAdminAPI
import MediaModule

extension Asset.Folder.Edit.Repository {
    protocol Interface: Sendable {
        func getFolder(
            id: String
        ) async throws -> Components.Schemas.MediaFolderDetailSchema

        func updateFolder(
            id: String,
            name: String
        ) async throws -> Components.Schemas.MediaFolderDetailSchema
    }
}
