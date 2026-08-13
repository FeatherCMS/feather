import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterCampaignSubscriberDefaultController:
    AdminEditNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditNewsletterCampaignSubscriberInteractor,
            presenter: any AdminEditNewsletterCampaignSubscriberPresenter
        )
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        do {
            return presenter.render(
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
            return presenter.render(
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
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
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
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath:
                            "/admin/newsletters/\(newsletterId)/subscribers/",
                        title: "Updated",
                        message: "Subscriber updated successfully."
                    )
                ]
            )
        }
        catch {
            return
                try presenter.render(
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
