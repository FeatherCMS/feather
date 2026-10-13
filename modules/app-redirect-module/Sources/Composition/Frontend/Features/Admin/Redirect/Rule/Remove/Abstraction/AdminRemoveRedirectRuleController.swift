import FeatherAdmin
import Hummingbird

protocol AdminRemoveRedirectRuleController: Sendable {

    func getRemoveRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postRemoveRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response

    func getRemoveRedirectRules(
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
        router.get(
            RedirectRuleRoutes.remove(RouterPath("{id}")),
            use: getRemoveRedirectRule
        )
        router.post(
            RedirectRuleRoutes.remove(RouterPath("{id}")),
            use: postRemoveRedirectRule
        )
        router.get(
            RedirectRuleRoutes.remove,
            use: getRemoveRedirectRules
        )
        router.post(
            RedirectRuleRoutes.remove,
            use: postRemoveRedirectRules
        )
    }
}
