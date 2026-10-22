import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Add {
    enum Controller {}
}

extension Rule.Add.Controller {
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
