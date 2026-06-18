import HTML
import Hummingbird

protocol AdminEditRedirectRuleController: Sendable {

    func getEditRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse

    func postEditRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}

extension AdminEditRedirectRuleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/rules/{id}/edit/",
            use: getEditRedirectRule
        )
        router.post(
            "/admin/redirect/rules/{id}/edit/",
            use: postEditRedirectRule
        )
    }
}
