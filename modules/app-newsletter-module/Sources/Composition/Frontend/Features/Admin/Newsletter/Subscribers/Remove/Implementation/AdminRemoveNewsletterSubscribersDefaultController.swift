import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersDefaultController:
    AdminRemoveNewsletterSubscribersController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveNewsletterSubscribersInteractor,
            any AdminRemoveNewsletterSubscribersPresenter
        >

    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else {
            return HTMLResponse(content: "Forbidden", status: .forbidden)
        }
        let ids = request.queryStrings("ids")
        guard !ids.isEmpty else {
            return HTMLResponse(
                content: "No subscribers selected.",
                status: .badRequest
            )
        }
        let names = try await interactor.names(ids: ids)
        return try await presenter.renderRemovePage(
            items: zip(ids, names).map {
                .init(id: $0.0, label: $0.1)
            },
            search: request.querySearch(),
            campaignId: request.queryString("campaignId"),
            returnTo: request.queryString("returnTo")
        )
    }

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
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
        try await interactor.remove(
            ids: payload.normalizedIds,
            campaignId: payload.campaignId?.emptyToNil
        )
        return AdminNotificationFlash.redirect(
            to: NewAdminLocation.url(
                path: NewsletterAdminRoutes.subscribers.description,
                queryItems: payload.campaignId?.emptyToNil
                    .map { [("campaignId", $0)] } ?? []
            ),
            notification: .init(
                title: "Removed",
                message: "Selected subscribers removed successfully."
            )
        )
    }
}
