import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.Remove {
    enum Presenter {}
}

extension WebModule.Menu.Remove.Presenter {
    protocol Interface: Sendable {

        func renderRemovePage(
            item: AdminRemoveItemContext
        ) async throws -> HTMLResponse

        func renderErrorPage(
            id: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse

    }
}
