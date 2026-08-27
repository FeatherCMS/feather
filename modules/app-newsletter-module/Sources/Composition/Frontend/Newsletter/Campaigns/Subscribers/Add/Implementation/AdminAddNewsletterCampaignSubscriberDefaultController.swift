import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignSubscriberDefaultController:
    AdminAddNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddNewsletterCampaignSubscriberInteractor,
            presenter: any AdminAddNewsletterCampaignSubscriberPresenter
        )
    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return presenter.render(
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
    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let form = try await request.decode(
            as: NewsletterCampaignSubscriberForm.self,
            context: context
        )
        do {
            try await interactor.create(newsletterId: newsletterId, form: form)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath:
                            "/admin/newsletters/\(newsletterId)/subscribers/",
                        title: "Added",
                        message: "Subscriber added successfully."
                    )
                ]
            )
        }
        catch {
            return
                try presenter.render(
                    newsletterId: newsletterId,
                    form: form,
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
