import Hummingbird

protocol AdminEditNewsletterSubscriberController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/subscribers/:subscriberId/edit/",
            use: edit
        )
        router.post(
            "/admin/newsletters/subscribers/:subscriberId/edit/",
            use: update
        )
    }
}
