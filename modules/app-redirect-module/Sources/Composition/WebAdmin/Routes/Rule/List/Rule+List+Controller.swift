import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectModule
import RedirectApplication

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

