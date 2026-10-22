import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import WebDomain
public import WebModule

extension Menu.Edit {
    enum Presenter {}
}

extension Menu.Edit.Presenter {
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
