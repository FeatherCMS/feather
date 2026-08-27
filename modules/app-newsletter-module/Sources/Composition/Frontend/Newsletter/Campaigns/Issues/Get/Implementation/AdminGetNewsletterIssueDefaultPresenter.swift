import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterIssueDefaultPresenter: AdminGetNewsletterIssuePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(
        model: AdminAddNewsletterIssueModel,
        issueId: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Campaign issue - Feather CMS",
            description: "View campaign issue",
            imagePath: "images/logos/logo.png",
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
                    error: nil,
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
