import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Variable.Remove {
    enum Presenter {}
}

extension WebAdmin.System.Variable.Remove.Presenter {
    protocol Interface: Sendable {

        func renderErrorPage(
            error: WebAdmin.System.Variable.Remove.Error,
            cancel: String
        ) async throws -> HTMLResponse

        func renderInvalidNoncePage(
            cancel: String
        ) async throws -> HTMLResponse

        func renderSuccess(
            location: String,
            count: Int
        ) -> Response

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse

    }
}
