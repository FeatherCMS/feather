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

extension Asset.Folder.Edit {
    enum Repository {}
}
