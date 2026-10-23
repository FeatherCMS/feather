import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignSubscriberDefaultController:
    AdminAddNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddNewsletterCampaignSubscriberInteractor,
            any AdminAddNewsletterCampaignSubscriberPresenter
        >
    func add(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let presenter = buildRuntime(request, context).presenter
        return try await presenter.render(
            newsletterId: try context.requiredParameter("newsletterId"),
            form: .init(
                email: "",
                firstName: "",
                lastName: "",
                status: "subscribed"
            ),
            error: nil,
            permissions: context.currentUserPermissions
        )
    }
    func create(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        let newsletterId = try context.requiredParameter("newsletterId")
        let form = try await request.decode(
            as: NewsletterCampaignSubscriberForm.self,
            context: context
        )
        do {
            try await interactor.create(newsletterId: newsletterId, form: form)
            return AdminNotificationFlash.redirect(
                to:
                    NewsletterAdminRoutes.campaignSubscribers(
                        RouterPath(newsletterId)
                    )
                    .description,
                notification: .init(
                    title: "Added",
                    message: "Subscriber added successfully."
                )
            )
        }
        catch {
            return
                try await presenter.render(
                    newsletterId: newsletterId,
                    form: form,
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
