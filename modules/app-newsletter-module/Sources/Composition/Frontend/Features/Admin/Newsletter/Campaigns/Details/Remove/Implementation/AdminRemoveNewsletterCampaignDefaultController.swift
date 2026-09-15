import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminRemoveNewsletterCampaignDefaultController:
    AdminRemoveNewsletterCampaignController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterCampaignInteractor,
            presenter: any AdminRemoveNewsletterCampaignPresenter
        )
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else {
            return try await presenter.render(
                id: "",
                permissions: context.currentUserPermissions
            )
        }
        return try await presenter.render(
            id: try context.requiredParameter("newsletterId"),
            permissions: context.currentUserPermissions
        )
    }
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return Response(status: .forbidden) }
        try await interactor.remove(
            id: try context.requiredParameter("newsletterId")
        )
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaigns.description,
            notification: .init(
                title: "Removed",
                message: "Campaign removed successfully."
            )
        )
    }
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return Response(status: .forbidden) }
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaigns.description,
            notification: .init(
                title: "Removed",
                message: "Campaigns removed successfully."
            )
        )
    }
}
