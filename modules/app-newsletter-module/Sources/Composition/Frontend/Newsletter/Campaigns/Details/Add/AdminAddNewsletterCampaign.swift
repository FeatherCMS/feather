import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaign {
    let controller: any AdminAddNewsletterCampaignController

    init(renderingEngine: any RenderingEngine) {
        controller = AdminAddNewsletterCampaignDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminAddNewsletterCampaignDefaultInteractor(
                        repository: AdminAddNewsletterCampaignOpenAPIRepository(
                            api: context.newsletterManagementAPI()
                        )
                    ),
                    presenter: AdminAddNewsletterCampaignDefaultPresenter(
                        request: request,
                        renderEngine: renderingEngine
                    )
                )
            }
        )
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
