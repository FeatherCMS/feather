import Hummingbird

protocol AdminNewsletterIssueListController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
}

extension AdminNewsletterIssueListController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:id/issues/", use: list)
    }
}
