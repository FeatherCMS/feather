import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssueDefaultPresenter:
    AdminAddNewsletterIssuePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        model: AdminAddNewsletterIssueModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletter/campaigns/"),
            .init(label: "Campaign", link: "/admin/newsletter/campaigns/"),
        ])
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Add campaign issue",
            description: "Add campaign issue",
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
                    issueId: nil,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
