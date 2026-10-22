import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import Hummingbird

struct AdminRemoveNewsletterIssueDefaultPresenter:
    AdminRemoveNewsletterIssuePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(newsletterId: String, item: AdminRemoveItemContext)
        async throws -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderAdminDialog(
            request: request,
            context: context,
            title: AdminRemoveConfirmation.dialogTitle,
            content: AdminRemoveConfirmation(
                header: .primary(
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
