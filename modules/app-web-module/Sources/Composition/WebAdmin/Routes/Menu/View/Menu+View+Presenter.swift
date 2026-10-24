import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.View {
    enum Presenter {}
}

extension WebModule.Menu.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            rule: WebModule.Menu.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
