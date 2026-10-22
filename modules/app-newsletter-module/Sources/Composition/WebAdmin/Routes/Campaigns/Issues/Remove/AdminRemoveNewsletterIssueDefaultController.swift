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

struct AdminRemoveNewsletterIssueDefaultController:
    AdminRemoveNewsletterIssueController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveNewsletterIssueInteractor,
            any AdminRemoveNewsletterIssuePresenter
        >
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let (interactor, _) = buildRuntime((request, context))
        let newsletterId = try context.requiredParameter("newsletterId")
        guard context.isCurrentUserAllowed(to: Issue.Permissions.delete)
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
