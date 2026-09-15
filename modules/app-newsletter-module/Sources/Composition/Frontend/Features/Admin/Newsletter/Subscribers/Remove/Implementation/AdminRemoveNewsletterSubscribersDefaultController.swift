import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterSubscribersDefaultController:
    AdminRemoveNewsletterSubscribersController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterSubscribersInteractor,
            presenter: any AdminRemoveNewsletterSubscribersPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        return try await presenter.renderRemovePage(
            items: request.queryStrings("selectedIds").map {
                .init(id: $0, label: $0)
            },
            search: request.querySearch(),
            campaignId: request.queryString("campaignId")
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard await AdminNonceStore.shared.consume(
            nonceRequest.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
        let payload = nonceRequest.input
        try await interactor.remove(
            ids: payload.normalizedSelectedIds,
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
