import FeatherAdmin
import Hummingbird

protocol AdminRemoveRedirectRuleController: Sendable {

    func postRemoveRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func postRemoveRedirectRules(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminRemoveRedirectRuleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.post(
            RedirectRuleRoutes.remove(RouterPath("{id}")),
            use: postRemoveRedirectRule
        )
        router.post(
            RedirectRuleRoutes.remove,
            use: postRemoveRedirectRules
        )
    }
}
