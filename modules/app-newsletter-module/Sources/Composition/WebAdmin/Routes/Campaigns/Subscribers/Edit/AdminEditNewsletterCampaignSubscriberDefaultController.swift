import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignSubscriberDefaultController:
    AdminEditNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminEditNewsletterCampaignSubscriberInteractor,
            any AdminEditNewsletterCampaignSubscriberPresenter
        >
    func edit(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        do {
            return try await presenter.render(
                newsletterId: newsletterId,
                item: try await interactor.get(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId
                ),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.render(
                newsletterId: newsletterId,
                item: .init(
                    id: subscriberId,
                    email: "",
                    firstName: "",
                    lastName: "",
                    status: "subscribed"
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        let form = try await request.decode(
            as: NewsletterCampaignSubscriberForm.self,
            context: context
        )
        do {
            try await interactor.update(
                newsletterId: newsletterId,
                subscriberId: subscriberId,
                form: form
            )
            return AdminNotificationFlash.redirect(
                to:
                    NewsletterAdminRoutes.campaignSubscriberEdit(
                        newsletterID: RouterPath(newsletterId),
                        subscriberID: RouterPath(subscriberId)
                    )
                    .description,
                notification: .init(
                    title: "Updated",
                    message: "Subscriber updated successfully."
                )
            )
        }
        catch {
            return
                try await presenter.render(
                    newsletterId: newsletterId,
                    item: .init(
                        id: subscriberId,
                        email: form.email,
                        firstName: form.firstName,
                        lastName: form.lastName,
                        status: form.status
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
