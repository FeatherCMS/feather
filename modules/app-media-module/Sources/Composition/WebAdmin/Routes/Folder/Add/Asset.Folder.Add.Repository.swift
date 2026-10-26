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

extension Asset.Folder.Add.Repository {
    protocol Interface: Sendable {
        func createFolder(
            name: String,
            parentId: String?
        ) async throws
    }
}

extension Asset.Folder.Add {
    enum Repository {}
}
