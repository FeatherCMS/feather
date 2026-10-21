import RedirectModule
import FeatherWebAdmin
import Hummingbird

extension RedirectModule.Rule.Remove {
    enum Presenter {}
}

extension RedirectModule.Rule.Remove.Presenter {
    protocol Interface: Sendable {
    func renderErrorPage(error: RedirectModule.Rule.Remove.Error, cancel: String)
        async throws -> HTMLResponse
    func renderSuccess(location: String, count: Int) -> Response
    func renderForbiddenPage() async throws -> HTMLResponse
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
    }
}
