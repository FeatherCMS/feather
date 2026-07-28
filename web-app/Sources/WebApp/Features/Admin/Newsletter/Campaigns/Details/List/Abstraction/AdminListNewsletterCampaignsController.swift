import Hummingbird

protocol AdminListNewsletterCampaignsController: Sendable {
    func list(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
}

extension AdminListNewsletterCampaignsController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/", use: list)
    }
}
