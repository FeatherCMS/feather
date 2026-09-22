import FeatherAdmin
import Hummingbird

protocol AdminAddRedirectRuleController: Sendable {

    func getAddRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse

    func postAddRedirectRule(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response
}

extension AdminAddRedirectRuleController {

    func route(
        on router: Router<DefaultRequestContext>
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
