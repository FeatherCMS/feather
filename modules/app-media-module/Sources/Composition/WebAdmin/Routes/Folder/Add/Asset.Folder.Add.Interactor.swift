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

extension Asset.Folder.Add {
    enum Interactor {}
}

extension Asset.Folder.Add.Interactor {
    protocol Interface: Sendable {
        func getAddMediaFolder(
            parentId: String?,
            view: String
        ) async throws
            -> Asset.Folder.Add.Model
        func postAddMediaFolder(
            payload: Asset.Folder.Add.Form.Input
        ) async throws
            -> Asset.Folder.Add.Model
    }
}
