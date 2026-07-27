import Hummingbird

protocol AdminAddContactNewsletterIssueController: Sendable {
    func getAddContactNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse
    func postAddContactNewsletterIssue(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response
}
extension AdminAddContactNewsletterIssueController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: getAddContactNewsletterIssue
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/add/",
            use: postAddContactNewsletterIssue
        )
    }
}
