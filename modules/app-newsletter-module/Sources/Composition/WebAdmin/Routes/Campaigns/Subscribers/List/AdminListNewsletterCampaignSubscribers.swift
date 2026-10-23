import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribers {
    let controller: any AdminListNewsletterCampaignSubscribersController
    init(
        apiBuilder: NewsletterAdminAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        controller = AdminListNewsletterCampaignSubscribersDefaultController {
            request,
            context in
            WebAdminRuntime(
                interactor: AdminListNewsletterCampaignSubscribersDefaultInteractor(
                    repository: .init(
                        api: apiBuilder.makeNewsletterAdmin(context)
                    )
                ),
                presenter: AdminListNewsletterCampaignSubscribersDefaultPresenter(
                    request: request,
                    context: context,
                    renderingEngine: renderingEngine
                )
            )
        }
    }
}
