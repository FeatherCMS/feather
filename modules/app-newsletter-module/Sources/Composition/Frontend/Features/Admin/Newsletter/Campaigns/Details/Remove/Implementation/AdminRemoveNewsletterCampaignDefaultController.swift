import FeatherAdmin
import Hummingbird
import NewsletterContracts

struct AdminRemoveNewsletterCampaignDefaultController:
    AdminRemoveNewsletterCampaignController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveNewsletterCampaignInteractor,
            any AdminRemoveNewsletterCampaignPresenter
        >
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return HTMLResponse(content: "Forbidden", status: .forbidden) }
        let id = try request.requiredParameter("newsletterId")
        return try await presenter.render(item: .init(id: id, label: id))
    }
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return Response(status: .forbidden) }
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        try await interactor.remove(
            id: try request.requiredParameter("newsletterId")
        )
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaigns.description,
            notification: .init(
                title: "Removed",
                message: "Campaign removed successfully."
            )
        )
    }
    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        let payload = nonceRequest.input
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return Response(status: .forbidden) }
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
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
