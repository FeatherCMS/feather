import FeatherWebAdmin
import Hummingbird
import RedirectModule

extension RedirectModule.Rule.View {
    enum Controller {}
}

extension RedirectModule.Rule.View.Controller {
    protocol Interface: Sendable {

    func getRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
    }
}

