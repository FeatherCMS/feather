import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebModule

extension MenuItem.Edit {
    enum Presenter {}
}

extension MenuItem.Edit.Presenter {
    protocol Interface: Sendable {
        func renderEditPage(
            menuId: String,
            id: String,
            state: MenuItem.Form.Component.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            menuId: String,
            id: String,
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
