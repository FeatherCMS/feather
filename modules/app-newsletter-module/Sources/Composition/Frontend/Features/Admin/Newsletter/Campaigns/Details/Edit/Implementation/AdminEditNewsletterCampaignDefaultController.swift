import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminEditNewsletterCampaignDefaultController:
    AdminEditNewsletterCampaignController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminEditNewsletterCampaignInteractor,
            any AdminEditNewsletterCampaignPresenter
        >
    func edit(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
        catch let error as AdminEditNewsletterCampaignError {
            return try await presenter.renderErrorPage(error: error)
        }
    }
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
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
                newKey: form.key,
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
        catch let error as AdminEditNewsletterCampaignError {
            return
                try await presenter.renderEditError(
                    id: id,
                    item: .init(
                        id: form.key,
                        name: form.name,
                        fromEmail: form.fromEmail
                    ),
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
