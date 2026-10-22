import FeatherWebAdmin
import WebDomain
import HTML
import OpenAPIRuntime

extension WebDomain.Menu.Edit {
    enum Presenter {}
}

extension WebDomain.Menu.Edit.Presenter {
    protocol Interface: Sendable {

        func renderEditPage(
            id: String,
            state: MenuForm.State,
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
