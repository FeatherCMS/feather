import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveNewsletterIssueDefaultController:
    AdminRemoveNewsletterIssueController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveNewsletterIssueInteractor,
            presenter: any AdminRemoveNewsletterIssuePresenter
        )
    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        let issueId = try context.requiredParameter("issueId")
        return try await presenter.render(
            newsletterId: try context.requiredParameter("newsletterId"),
            item: .init(id: issueId, label: issueId)
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
        guard await AdminNonceStore.shared.consume(
            nonceRequest.nonce,
            sessionToken: context.sessionToken
        ) else { return Response(status: .badRequest) }
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
