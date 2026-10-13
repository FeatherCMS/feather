import FeatherAdmin
import Hummingbird

protocol AdminAddRedirectRuleController: Sendable {

    func getAddRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

    func postAddRedirectRule(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response
}

extension AdminAddRedirectRuleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.add,
            use: getAddRedirectRule
        )
        router.post(
            RedirectRuleRoutes.add,
            use: postAddRedirectRule
        )
    }
}
