import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebModule

extension Page.View {
    enum Presenter {}
}

extension Page.View.Presenter {
    protocol Interface: Sendable {

        func renderDetailsPage(
            rule: Page.Details.Model,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: AdminListActions
        ) async throws -> HTMLResponse

    }
}
