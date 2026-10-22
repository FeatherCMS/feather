import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse
        func renderErrorPage(error: Identity.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        func renderSuccess(location: String, count: Int) -> Response
        func renderUnauthorizedPage() async throws -> HTMLResponse
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
    }
}
