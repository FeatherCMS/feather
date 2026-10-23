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

struct AdminRemoveNewsletterCampaignSubscriberDefaultController:
    AdminRemoveNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminRemoveNewsletterCampaignSubscriberInteractor,
            any AdminRemoveNewsletterCampaignSubscriberPresenter
        >

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let interactor = buildRuntime(request, context).interactor
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Subscriber.Permissions.delete)
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
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberId: try context.requiredParameter("subscriberId")
        )
        return AdminNotificationFlash.redirect(
            to:
                NewsletterAdminRoutes.campaignSubscribers(
                    RouterPath(newsletterId)
                )
                .description,
            notification: .init(
                title: "Removed",
                message: "Subscriber removed successfully."
            )
        )
    }

    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
    {
        let interactor = buildRuntime(request, context).interactor
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Subscriber.Permissions.delete)
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
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberIds: nonceRequest.input.normalizedIds
        )
        return AdminNotificationFlash.redirect(
            to:
                NewsletterAdminRoutes.campaignSubscribers(
                    RouterPath(newsletterId)
                )
                .description,
            notification: .init(
                title: "Removed",
                message: "Subscribers removed successfully."
            )
        )
    }
}
