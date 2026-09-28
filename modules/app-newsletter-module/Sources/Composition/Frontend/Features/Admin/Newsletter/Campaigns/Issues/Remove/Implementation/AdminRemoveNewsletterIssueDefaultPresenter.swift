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
        return try await renderingEngine.renderNewAdminDialog(
            request: request,
            context: context,
            title: NewAdminRemoveConfirmation.dialogTitle,
            content: NewAdminRemoveConfirmation(
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
                submit: .init(label: "Remove issue", style: .destructive),
                nonceToken: nonceToken,
                hiddenFields: [.init(name: "ids", value: item.id)]
            ),
            size: .small
        )
    }
}
