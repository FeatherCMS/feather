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

extension Asset.File.Edit {
    enum Interactor {}
}

extension Asset.File.Edit.Interactor {
    protocol Interface: Sendable {
        func load(
            id: String
        ) async throws -> Asset.File.Edit.Model
        func update(
            id: String,
            input: AssetEditForm
        ) async throws
            -> Asset.File.Edit.Model
    }
}
