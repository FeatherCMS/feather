import FeatherAdmin
import Hummingbird

struct AdminRemoveNewsletterIssueDefaultPresenter:
    AdminRemoveNewsletterIssuePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(newsletterId: String, issueId: String, permissions: Set<String>)
        async throws -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove campaign issue",
            content: NewAdminConfirmation(
                breadcrumb: NewsletterAdminRoutes.breadcrumb + [
                    .init(
                        label: "Issues",
                        link:
                            NewsletterAdminRoutes.campaignIssues(
                                RouterPath(newsletterId)
                            )
                            .description
                    )
                ],
                pageHeader: .init(
                    title: "Remove campaign issue",
                    description: "This action cannot be undone."
                ),
                action:
                    NewsletterAdminRoutes.issueRemove(
                        newsletterID: RouterPath(newsletterId),
                        issueID: RouterPath(issueId)
                    )
                    .description,
                cancel:
                    NewsletterAdminRoutes.campaignIssues(
                        RouterPath(newsletterId)
                    )
                    .description,
                submitLabel: "Remove issue"
            )
        )
    }
}
