import FeatherAdmin
import Hummingbird

protocol AdminListRedirectRuleController: Sendable {

    func getRedirectRules(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse

}

extension AdminListRedirectRuleController {

    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>
    ) {
        router.get(
            RedirectRuleRoutes.list,
            use: getRedirectRules
        )
    }
}
