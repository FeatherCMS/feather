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
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return HTMLResponse(content: "Forbidden", status: .forbidden) }
        let id = try context.requiredParameter("newsletterId")
        let names = try await interactor.names(ids: [id])
        return try await presenter.renderRemovePage(
            items: [.init(id: id, label: names.first ?? id)],
            returnTo: request.queryString("returnTo")
        )
    }

    func confirmSelected(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Campaigns.delete)
        else { return Response(status: .forbidden) }
        let ids = request.queryStrings("ids")
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewsletterAdminRoutes.campaigns.description
                ]
            )
        }
        let names = try await interactor.names(ids: ids)
        return
            try await presenter.renderRemovePage(
                items: zip(ids, names).map { .init(id: $0.0, label: $0.1) },
                returnTo: request.queryString("returnTo")
            )
            .response(from: request, context: context)
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

    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
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
        let payload = nonceRequest.input
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return AdminNotificationFlash.redirect(
            to: NewAdminLocation.url(
                path: NewsletterAdminRoutes.campaigns.description,
                page: payload.normalizedPage,
                search: payload.normalizedSearch
            ),
            notification: .init(
                title: "Removed",
                message: "Campaigns removed successfully."
            )
        )
    }
}
