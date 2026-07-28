import Hummingbird

protocol AdminAddNewsletterCampaignSubscriberController: Sendable {
    func add(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func create(request: Request, context: AppRequestContext) async throws
        -> Response
}
extension AdminAddNewsletterCampaignSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/add/",
            use: add
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/add/",
            use: create
        )
    }
}
