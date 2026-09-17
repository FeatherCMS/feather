import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignSubscriberDefaultController:
    AdminRemoveNewsletterCampaignSubscriberController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterCampaignSubscriberInteractor,
            presenter: any AdminRemoveNewsletterCampaignSubscriberPresenter
        )
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        let item = try await interactor.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
        return try await presenter.render(
            newsletterId: newsletterId,
            item: .init(id: subscriberId, label: item.email)
        )
    }
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
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
    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
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
            newsletterId: newsletterId,
            subscriberIds: payload.normalizedSelectedIds
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
