import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterIssuesDefaultPresenter:
    AdminListNewsletterIssuesPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Newsletter", link: "/admin/newsletters/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(
                label: "Issues",
                link: "/admin/newsletters/\(newsletterId)/issues/"
            ),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Campaign issues",
            description: "Manage campaign issues",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminNewsletterIssuesListView(
                state: .init(
                    newsletterId: newsletterId,
                    items: items,
                    error: error,
                    permissions: permissions,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
