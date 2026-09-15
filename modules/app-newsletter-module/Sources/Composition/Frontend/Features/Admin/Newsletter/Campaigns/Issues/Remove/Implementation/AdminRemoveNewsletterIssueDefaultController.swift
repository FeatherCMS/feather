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
        return try await presenter.render(
            newsletterId: try context.requiredParameter("newsletterId"),
            issueId: try context.requiredParameter("issueId"),
            permissions: context.currentUserPermissions
        )
    }
    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let newsletterId = try context.requiredParameter("newsletterId")
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
