import HTML
import Hummingbird

protocol AdminAddRedirectRuleController: Sendable {

    func getAddRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postAddRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminAddRedirectRuleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/rules/add/",
            use: getAddRedirectRule
        )
        router.post(
            "/admin/redirect/rules/add/",
            use: postAddRedirectRule
        )
    }
}
