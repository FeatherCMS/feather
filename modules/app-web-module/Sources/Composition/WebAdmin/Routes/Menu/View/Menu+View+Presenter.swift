import FeatherWebAdmin
import WebDomain
import HTML
import OpenAPIRuntime

extension WebDomain.Menu.View {
    enum Presenter {}
}

extension WebDomain.Menu.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            rule: MenuDetailsModel,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
