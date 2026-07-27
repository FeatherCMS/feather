import Hummingbird

protocol AdminAddNewsletterIssueController: Sendable {
    func getAddNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
    func postAddNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}
extension AdminAddNewsletterIssueController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: getAddNewsletterIssue
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: postAddNewsletterIssue
        )
    }
}
