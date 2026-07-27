import Hummingbird

protocol AdminRemoveNewsletterIssueController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminRemoveNewsletterIssueController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/issues/:issueId/remove/",
            use: confirm
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/:issueId/remove/",
            use: remove
        )
    }
}
