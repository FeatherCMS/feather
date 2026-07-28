import Hummingbird

protocol AdminEditNewsletterCampaignController: Sendable {
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
}

extension AdminEditNewsletterCampaignController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/:newsletterId/edit/", use: edit)
        router.post("/admin/newsletters/:newsletterId/edit/", use: update)
    }
}
