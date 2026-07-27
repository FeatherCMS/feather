import Hummingbird

protocol AdminAddNewsletterSubscriberController: Sendable {
    func get(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func post(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminAddNewsletterSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/subscribers/add/", use: get)
        router.post("/admin/newsletters/subscribers/add/", use: post)
    }
}
