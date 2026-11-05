import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Tag.View {
    enum Presenter {}
}

extension Tag.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            model: Tag.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
