import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterIssueDefaultPresenter:
    AdminAddNewsletterIssuePresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        model: AdminAddNewsletterIssueModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Campaign", link: "/admin/newsletters/"),
            .init(
                label: "Add issue",
                link: "/admin/newsletters/\(model.newsletterId)/issues/add/"
            ),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add campaign issue - Feather CMS",
            description: "Add campaign issue - Feather CMS",
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
                    issueId: nil,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
