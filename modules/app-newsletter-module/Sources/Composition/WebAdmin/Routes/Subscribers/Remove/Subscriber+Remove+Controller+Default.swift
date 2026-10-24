import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Remove.Controller {
    struct Default: Interface {
        let routes: Subscriber.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Subscriber.Remove.Interactor.Interface,
                any Subscriber.Remove.Presenter.Interface
            >

        func remove(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let interactor = buildRuntime(request, context).interactor
            guard
                context.isCurrentUserAllowed(to: Subscriber.Permissions.delete)
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
                    path: routes.list.path,
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
}
