import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Remove.Controller {
    struct Default: Interface {
        let routes: Campaign.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Campaign.Subscriber.Remove.Interactor.Interface,
                Void
            >

        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let newsletterId = try context.requiredParameter("newsletterId")
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

            try await buildRuntime(request, context).interactor
                .remove(
                    newsletterId: newsletterId,
                    subscriberIds: nonceRequest.input.normalizedIds
                )
            return AdminNotification.redirect(
                to: routes.subscribersPath(newsletterId: newsletterId),
                notification: .init(
                    title: "Removed",
                    message: "Subscribers removed successfully."
                )
            )
        }
    }
}
