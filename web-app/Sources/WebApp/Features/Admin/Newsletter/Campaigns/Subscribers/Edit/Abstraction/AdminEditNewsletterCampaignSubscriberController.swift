import Hummingbird

protocol AdminEditNewsletterCampaignSubscriberController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}
extension AdminEditNewsletterCampaignSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/",
            use: edit
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/edit/",
            use: update
        )
    }
}
