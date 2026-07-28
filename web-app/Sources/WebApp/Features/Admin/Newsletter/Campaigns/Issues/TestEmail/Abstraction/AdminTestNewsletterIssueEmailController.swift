import Hummingbird

protocol AdminTestNewsletterIssueEmailController: Sendable {
    func send(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminTestNewsletterIssueEmailController {
    func route(on router: Router<AppRequestContext>) {
        router.post(
            "/admin/newsletters/:newsletterId/issues/test-email/",
            use: send
        )
        router.post(
            "/admin/newsletters/:newsletterId/issues/:issueId/test-email/",
            use: send
        )
    }
}
