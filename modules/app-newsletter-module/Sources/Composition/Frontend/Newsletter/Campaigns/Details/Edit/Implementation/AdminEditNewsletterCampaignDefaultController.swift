import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterCampaignDefaultController:
    AdminEditNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditNewsletterCampaignInteractor,
            presenter: any AdminEditNewsletterCampaignPresenter
        )
    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("newsletterId")
        do {
            return presenter.render(
                item: try await interactor.get(id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("newsletterId")
        let form = try await request.decode(
            as: NewsletterEditForm.self,
            context: context
        )
        do {
            try await interactor.update(
                id: id,
                name: form.name,
                fromEmail: form.fromEmail
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/newsletters/",
                        title: "Updated",
                        message: "Campaign updated successfully."
                    )
                ]
            )
        }
        catch {
            return
                try presenter.render(
                    item: .init(
                        id: id,
                        name: form.name,
                        fromEmail: form.fromEmail
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
