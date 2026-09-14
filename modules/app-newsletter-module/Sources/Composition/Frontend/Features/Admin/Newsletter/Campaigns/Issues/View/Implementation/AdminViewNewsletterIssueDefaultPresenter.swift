import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterIssueDefaultPresenter:
    AdminViewNewsletterIssuePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Campaign issue",
            content: NewsletterIssueAddView(
                state: .init(
                    subject: model.subject,
                    content: model.content,
                    scheduledAt: model.scheduledAt,
                    newsletterId: model.newsletterId,
                    issueId: issueId,
                    error: nil
                )
            )
        )
    }
}
