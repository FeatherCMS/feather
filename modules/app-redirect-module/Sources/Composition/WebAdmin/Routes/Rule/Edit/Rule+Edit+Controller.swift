import FeatherWebAdmin
import Hummingbird
import RedirectApplication
import RedirectModule

extension RedirectModule.Rule.Edit {
    enum Controller {}
}

extension RedirectModule.Rule.Edit.Controller {
    protocol Interface: Sendable {

    func getEditRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    }
}

