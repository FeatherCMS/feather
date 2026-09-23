import FeatherAdmin
import Hummingbird

protocol AdminEditRedirectRuleController: Sendable {

    func getEditRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postEditRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminEditRedirectRuleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.edit(RouterPath("{id}")),
            use: getEditRedirectRule
        )
        router.post(
            RedirectRuleRoutes.edit(RouterPath("{id}")),
            use: postEditRedirectRule
        )
    }
}
