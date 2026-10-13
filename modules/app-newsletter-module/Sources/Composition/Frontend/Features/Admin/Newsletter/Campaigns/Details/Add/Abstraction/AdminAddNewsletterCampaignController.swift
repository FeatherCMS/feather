import FeatherAdmin
import Hummingbird

protocol AdminAddNewsletterCampaignController: Sendable {
    func getAddNewsletterCampaign(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    func postAddNewsletterCampaign(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> Response
}

extension AdminAddNewsletterCampaignController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.get(
            NewsletterAdminRoutes.campaignAdd,
            use: getAddNewsletterCampaign
        )
        router.post(
            NewsletterAdminRoutes.campaignAdd,
            use: postAddNewsletterCampaign
        )
    }
}
