import HTML
import Hummingbird

protocol AdminRemoveRedirectRuleController: Sendable {

    func getRemoveRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postRemoveRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminRemoveRedirectRuleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/rules/{id}/remove/",
            use: getRemoveRedirectRule
        )
        router.post(
            "/admin/redirect/rules/{id}/remove/",
            use: postRemoveRedirectRule
        )
    }
}
