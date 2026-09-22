import FeatherAdmin
import FeatherContracts
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
            title: "Campaign issue details",
            content: NewsletterIssueDetailsView(
                newsletterId: model.newsletterId,
                issueId: issueId,
                model: model,
                permissions: NewAdminListActions(
                    Set(permissions.map(PermissionKey.init))
                )
            )
        )
    }
}
