import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule

extension Rule.Remove.Controller {
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
