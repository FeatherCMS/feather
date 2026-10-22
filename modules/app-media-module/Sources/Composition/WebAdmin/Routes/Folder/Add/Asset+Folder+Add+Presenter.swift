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

extension Asset.Folder.Add.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            model: Asset.Folder.Add.Model
        ) async throws -> HTMLResponse
    }
}
