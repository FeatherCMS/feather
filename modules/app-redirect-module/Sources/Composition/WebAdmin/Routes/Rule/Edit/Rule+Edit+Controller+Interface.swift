import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Edit.Controller {
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
