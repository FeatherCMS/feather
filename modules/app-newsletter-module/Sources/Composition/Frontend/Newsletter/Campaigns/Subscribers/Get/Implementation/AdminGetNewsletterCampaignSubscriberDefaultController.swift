import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterCampaignSubscriberDefaultController:
    AdminGetNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetNewsletterCampaignSubscriberInteractor,
            presenter: any AdminGetNewsletterCampaignSubscriberPresenter
        )
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        return presenter.render(
            newsletterId: newsletterId,
            item: try await interactor.get(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            ),
            permissions: context.currentUserPermissions
        )
    }
}
