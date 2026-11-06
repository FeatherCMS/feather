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

extension Asset.Folder.Edit {
    enum Interactor {}
}

extension Asset.Folder.Edit.Interactor {
    protocol Interface: Sendable {
        func load(
            id: String
        ) async throws -> Asset.Folder.Edit.Model
        func update(
            id: String,
            input: Asset.Folder.Edit.Form.Input
        ) async throws
            -> Asset.Folder.Edit.Model
    }
}
