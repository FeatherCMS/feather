import FeatherWebAdmin
import Hummingbird
import RedirectModule

extension RedirectModule.Rule.Remove {
    enum Controller {}
}

extension RedirectModule.Rule.Remove.Controller {
    protocol Interface: Sendable {

    func postRemoveRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveRedirectRules(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
    }
}

