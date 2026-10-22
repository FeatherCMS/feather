import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Settings.Edit.Presenter {
    protocol Interface: Sendable {
        func renderPage(
            state: Settings.Edit.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderDeniedPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
