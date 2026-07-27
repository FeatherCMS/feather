import Hummingbird

protocol AdminListNewsletterCampaignSubscribersController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}
extension AdminListNewsletterCampaignSubscribersController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/subscribers/", use: list)
    }
}
