import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.Remove {
    enum Presenter {}
}

extension WebAdmin.System.Permission.Remove.Presenter {
    protocol Interface: Sendable {

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: WebAdmin.System.Permission.Remove.Error,
            cancel: String
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse

        func renderSuccess(location: String, count: Int) -> Response
    }
}
