import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterIssuesDefaultPresenter:
    AdminListNewsletterIssuesPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        items: [AdminNewsletterIssueItem],
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Newsletter", link: "/admin/newsletter/"),
            .init(label: "Campaigns", link: "/admin/newsletter/campaigns/"),
        ])
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Campaign issues",
            description: "Manage campaign issues",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
