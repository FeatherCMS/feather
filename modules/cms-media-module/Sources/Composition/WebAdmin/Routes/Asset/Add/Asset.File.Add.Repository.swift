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

extension Asset.File.Add {
    enum Repository {}
}
