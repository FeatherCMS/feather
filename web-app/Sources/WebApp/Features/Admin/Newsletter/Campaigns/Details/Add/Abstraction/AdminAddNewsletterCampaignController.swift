import Hummingbird

protocol AdminAddNewsletterCampaignController: Sendable {
    func getAddNewsletterCampaign(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    func postAddNewsletterCampaign(request: Request, context: AppRequestContext)
        async throws -> Response
}

extension AdminAddNewsletterCampaignController {
    func route(on router: Router<AppRequestContext>) {
        router.get("/admin/newsletters/add/", use: getAddNewsletterCampaign)
        router.post("/admin/newsletters/add/", use: postAddNewsletterCampaign)
    }
}
