import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignSubscribers {
    let controller: any AdminListNewsletterCampaignSubscribersController
    init(renderingEngine: any RenderingEngine) {
        controller = AdminListNewsletterCampaignSubscribersDefaultController {
            request,
            context in
            (
                AdminListNewsletterCampaignSubscribersDefaultInteractor(
                    repository: .init(api: context.newsletterManagementAPI())
                ),
                AdminListNewsletterCampaignSubscribersDefaultPresenter(
                    request: request,
                    renderEngine: renderingEngine
                )
            )
        }
    }
    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
