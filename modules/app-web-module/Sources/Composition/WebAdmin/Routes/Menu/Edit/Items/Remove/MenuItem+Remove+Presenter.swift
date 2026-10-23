import FeatherWebAdmin
import Hummingbird
import OpenAPIRuntime
import WebModule

extension MenuItem.Remove {
    enum Presenter {}
}

extension MenuItem.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            menuId: String,
            item: AdminRemoveItemContext,
            origin: MenuItem.Router.Routes.RemoveOrigin
        ) async throws -> HTMLResponse

        func renderErrorPage(
            menuId: String,
            info: String,
            message: String
        ) async throws -> HTMLResponse
    }
}
