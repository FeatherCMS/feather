import FeatherWebAdmin
import Hummingbird
import RedirectModule
import RedirectApplication

extension RedirectModule.Rule.Add {
    enum Controller {}
}

extension RedirectModule.Rule.Add.Controller {
    protocol Interface: Sendable {
        func getAddRedirectRule(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse

        func postAddRedirectRule(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}

