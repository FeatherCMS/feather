import Hummingbird

protocol AdminRemoveNewsletterCampaignSubscriberController: Sendable {
    func confirm(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func remove(request: Request, context: AppRequestContext) async throws
        -> Response
    func removeSelected(request: Request, context: AppRequestContext)
        async throws -> Response
}
extension AdminRemoveNewsletterCampaignSubscriberController {
    func route(on router: Router<AppRequestContext>) {
        router.get(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/",
            use: confirm
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/:subscriberId/remove/",
            use: remove
        )
        router.post(
            "/admin/newsletters/:newsletterId/subscribers/remove/",
            use: removeSelected
        )
    }
}
