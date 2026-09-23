import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriberDefaultController:
    AdminViewNewsletterCampaignSubscriberController
{
    let buildRuntime: RuntimeBuilder<
        any AdminViewNewsletterCampaignSubscriberInteractor,
        any AdminViewNewsletterCampaignSubscriberPresenter
    >
    func get(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        return try await presenter.render(
            newsletterId: newsletterId,
            item: try await interactor.get(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            ),
            permissions: context.currentUserPermissions
        )
    }
}
