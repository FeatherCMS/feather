import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterCampaignController: Sendable {
    func getAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> HTMLResponse
    func postAddNewsletterCampaign(
        request: Request,
        context: DefaultRequestContext
    )
        async throws -> Response
}

extension AdminAddNewsletterCampaignController {
    func route(on router: Router<DefaultRequestContext>) {
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
