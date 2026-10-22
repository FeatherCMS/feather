import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.Folder.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            model: Asset.Folder.Edit.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
    }
}
