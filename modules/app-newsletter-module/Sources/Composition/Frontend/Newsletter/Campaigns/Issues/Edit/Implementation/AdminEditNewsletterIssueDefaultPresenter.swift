import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminEditNewsletterIssueDefaultPresenter:
    AdminEditNewsletterIssuePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String?,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit campaign issue - Feather CMS",
            description: "Edit campaign issue",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
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
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                        .init(
                            label: "Issues",
                            link:
                                "/admin/newsletters/\(model.newsletterId)/issues/"
                        ),
                    ])
                )
            )
        )
    }
}
