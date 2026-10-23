import FeatherWebAdmin
import FeatherWebShared
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
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewNewsletterCampaignSubscriberInteractor,
            any AdminViewNewsletterCampaignSubscriberPresenter
        >
    func get(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
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
