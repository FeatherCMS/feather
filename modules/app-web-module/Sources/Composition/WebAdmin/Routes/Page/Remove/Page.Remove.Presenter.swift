import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension Page.Remove {
    enum Presenter {}
}

extension Page.Remove.Presenter {
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
