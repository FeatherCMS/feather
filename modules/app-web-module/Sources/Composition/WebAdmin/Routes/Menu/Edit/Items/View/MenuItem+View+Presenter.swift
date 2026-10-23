import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebModule

extension MenuItem.View {
    enum Presenter {}
}

extension MenuItem.View.Presenter {
    protocol Interface: Sendable {
        func renderDetailsPage(
            model: MenuItem.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            menuId: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
