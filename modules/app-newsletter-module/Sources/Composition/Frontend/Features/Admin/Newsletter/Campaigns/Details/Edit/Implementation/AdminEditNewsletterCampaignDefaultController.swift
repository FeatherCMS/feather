import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminEditNewsletterCampaignDefaultController:
    AdminEditNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditNewsletterCampaignInteractor,
            presenter: any AdminEditNewsletterCampaignPresenter
        )
    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.update)
        else {
            return try await presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: "Your account cannot edit newsletter campaigns.",
                permissions: context.currentUserPermissions
            )
        }
        do {
            return try await presenter.render(
                item: try await interactor.get(id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.render(
                item: .init(id: id, name: "", fromEmail: ""),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.update)
        else {
            return Response(status: .forbidden)
        }
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
            return AdminNotificationFlash.redirect(
                to: NewsletterAdminRoutes.campaigns.description,
                notification: .init(
                    title: "Updated",
                    message: "Campaign updated successfully."
                )
            )
        }
        catch {
            return
                try await presenter.render(
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
