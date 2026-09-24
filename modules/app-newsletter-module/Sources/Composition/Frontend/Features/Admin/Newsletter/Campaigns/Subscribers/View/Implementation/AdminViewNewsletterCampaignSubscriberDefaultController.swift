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
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewNewsletterCampaignSubscriberInteractor,
            any AdminViewNewsletterCampaignSubscriberPresenter
        >
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        let newsletterId = try request.requiredParameter("newsletterId")
        let subscriberId = try request.requiredParameter("subscriberId")
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
