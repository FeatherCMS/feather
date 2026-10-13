import FeatherAdmin
import Hummingbird

protocol AdminViewRedirectRuleController: Sendable {

    func getRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse
}

extension AdminViewRedirectRuleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.details(RouterPath("{id}")),
            use: getRedirectRule
        )
    }
}
