import Hummingbird

protocol AdminGetNewsletterSubscriberController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminGetNewsletterSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/:subscriberId/", use: get)
    }
}
