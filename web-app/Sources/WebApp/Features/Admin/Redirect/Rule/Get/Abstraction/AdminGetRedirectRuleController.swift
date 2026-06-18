import Hummingbird

protocol AdminGetRedirectRuleController: Sendable {

    func getRedirectRule(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
}

extension AdminGetRedirectRuleController {

    func route(
        on router: Router<AppRequestContext>
    ) {
        router.get(
            "/admin/redirect/rules/{id}/",
            use: getRedirectRule
        )
    }
}
