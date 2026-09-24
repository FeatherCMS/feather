import FeatherAdmin
import FeatherValidation
import Hummingbird

struct AdminRemoveNewsletterIssueDefaultPresenter:
    AdminRemoveNewsletterIssuePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(newsletterId: String, item: NewAdminRemoveItemContext)
        async throws -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove campaign issue",
            content: NewAdminRemoveConfirmation(
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
                selectedItems: [item.label],
                action:
                    NewsletterAdminRoutes.issueRemove(
                        newsletterID: RouterPath(newsletterId),
                        issueID: RouterPath(item.id)
                    )
                    .description,
                cancel:
                    NewsletterAdminRoutes.campaignIssues(
                        RouterPath(newsletterId)
                    )
                    .description,
                submitLabel: "Remove issue",
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            )
        )
    }
}
