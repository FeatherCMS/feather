import Hummingbird

protocol AdminNewsletterSubscribersDirectoryController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse
}

extension AdminNewsletterSubscribersDirectoryController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/", use: list)
    }
}
