import FeatherWebAdmin
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Remove.Presenter {
    protocol Interface: Sendable {
        func renderErrorPage(error: Rule.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        func renderSuccess(location: String, count: Int) -> Response
        func renderForbiddenPage() async throws -> HTMLResponse
        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
    }
}
