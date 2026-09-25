import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import NewsletterContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssueDefaultController:
    AdminRemoveNewsletterIssueController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveNewsletterIssueInteractor,
            any AdminRemoveNewsletterIssuePresenter
        >
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard context.isCurrentUserAllowed(to: Permissions.Issues.delete)
        else { return HTMLResponse(content: "Forbidden", status: .forbidden) }
        let issueId = try context.requiredParameter("issueId")
        return try await presenter.render(
            newsletterId: try context.requiredParameter("newsletterId"),
            item: try await interactor.get(
                newsletterId: try context.requiredParameter("newsletterId"),
                issueId: issueId
            )
        )
    }
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Permissions.Issues.delete)
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
            newsletterId: newsletterId,
            issueId: try context.requiredParameter("issueId")
        )
        return AdminNotificationFlash.redirect(
            to: NewsletterAdminRoutes.campaignIssues(RouterPath(newsletterId))
                .description,
            notification: .init(
                title: "Removed",
                message: "Campaign issue removed successfully."
            )
        )
    }
}
