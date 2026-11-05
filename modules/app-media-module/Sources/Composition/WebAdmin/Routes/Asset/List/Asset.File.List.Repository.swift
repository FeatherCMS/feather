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

extension Asset.File.List.Repository {
    protocol Interface: Sendable {
        func search(
            page: Int,
            search: String?,
            parentId: String?,
            allowedExtensions: [String]
        ) async throws -> Result

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
        ) async throws -> Asset.Folder.Detail.Model
    }
}

extension Asset.File.List {
    enum Repository {}
}
