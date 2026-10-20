import FeatherWebAdmin
import Hummingbird
import SystemModule

extension Variable.Remove {
    enum Presenter {}
}

extension Variable.Remove.Presenter {
    protocol Interface: Sendable {

        func renderErrorPage(
            error: Variable.Remove.Error,
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
