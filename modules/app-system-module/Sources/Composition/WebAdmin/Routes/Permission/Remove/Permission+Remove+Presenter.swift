import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Permission.Remove {
    enum Presenter {}
}

extension Permission.Remove.Presenter {
    protocol Interface: Sendable {

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse

        func renderErrorPage(
            error: Permission.Remove.Error,
            cancel: String
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse

        func renderSuccess(location: String, count: Int) -> Response
    }
}
