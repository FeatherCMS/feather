import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebModule

extension Page.Edit {
    enum Presenter {}
}

extension Page.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: Page.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
