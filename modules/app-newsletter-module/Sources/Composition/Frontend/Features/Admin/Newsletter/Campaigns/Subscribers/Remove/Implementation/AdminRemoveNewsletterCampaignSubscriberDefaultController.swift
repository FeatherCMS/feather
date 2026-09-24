import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterCampaignSubscriberDefaultController:
    AdminRemoveNewsletterCampaignSubscriberController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveNewsletterCampaignSubscriberInteractor,
            any AdminRemoveNewsletterCampaignSubscriberPresenter
        >

    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else { return HTMLResponse(content: "Forbidden", status: .forbidden) }
        let newsletterId = try context.requiredParameter("newsletterId")
        let subscriberId = try context.requiredParameter("subscriberId")
        let item = try await interactor.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
        return try await presenter.render(
            newsletterId: newsletterId,
            items: [.init(id: subscriberId, label: item.email)],
            returnTo: request.queryString("returnTo")
        )
    }

    func confirmSelected(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else { return Response(status: .forbidden) }
        let newsletterId = try context.requiredParameter("newsletterId")
        let ids = request.queryStrings("ids")
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewsletterAdminRoutes.campaignSubscribers(
                        RouterPath(newsletterId)
                    ).description
                ]
            )
        }
        let names = try await interactor.names(
            newsletterId: newsletterId,
            subscriberIds: ids
        )
        return try await presenter.render(
            newsletterId: newsletterId,
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
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else { return Response(status: .forbidden) }
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard await AdminNonceStore.shared.consume(
            nonceRequest.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberId: try context.requiredParameter("subscriberId")
        )
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaignSubscribers(RouterPath(newsletterId))
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
        let (interactor, _) = buildRuntime((request, context))
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Subscribers.delete)
        else { return Response(status: .forbidden) }
        let nonceRequest = try await request.decode(
            as: NonceRequest<NewAdminListRemoveFormInput>.self,
            context: context
        )
        guard await AdminNonceStore.shared.consume(
            nonceRequest.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
        try await interactor.remove(
            newsletterId: newsletterId,
            subscriberIds: nonceRequest.input.normalizedIds
        )
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaignSubscribers(RouterPath(newsletterId))
                .description,
            notification: .init(
                title: "Removed",
                message: "Subscribers removed successfully."
            )
        )
    }
}
