import FeatherWebAdmin
import FeatherModuleKit
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


    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else { return Response(status: .forbidden) }
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
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
            to: AdminLocation.url(
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
