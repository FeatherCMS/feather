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

extension Asset.File.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            model: Asset.File.View.Model?,
            id: String,
            permissions: AdminListActions,
            error: String?
        ) async throws -> HTMLResponse
    }
}
