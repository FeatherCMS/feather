import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterIssueDefaultPresenter:
    AdminEditNewsletterIssuePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String?,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Edit campaign issue",
            description: "Edit campaign issue",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterIssueAddView(
                state: .init(
                    subject: model.subject,
                    content: model.content,
                    scheduledAt: model.scheduledAt,
                    newsletterId: model.newsletterId,
                    issueId: issueId,
                    error: error,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(
                            label: "Campaigns",
                            link: "/admin/newsletter/campaigns/"
                        ),
                        .init(
                            label: "Issues",
                            link:
                                "/admin/newsletter/\(model.newsletterId)/issues/"
                        ),
                    ])
                )
            )
        )
    }
}
