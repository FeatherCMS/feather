import FeatherWebAdmin
import Hummingbird
import RedirectModule

extension RedirectModule.Rule.List {
    enum Controller {}
}

extension RedirectModule.Rule.List.Controller {
    protocol Interface: Sendable {

    func getRedirectRules(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    }
}

