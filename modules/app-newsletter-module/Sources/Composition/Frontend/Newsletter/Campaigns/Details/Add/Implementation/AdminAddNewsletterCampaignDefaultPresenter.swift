import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterCampaignDefaultPresenter:
    AdminAddNewsletterCampaignPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Add", link: "/admin/newsletters/add/"),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add campaign",
            description: "Add campaign",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterCampaignAddView(
                state: .init(
                    name: model.name,
                    fromEmail: model.fromEmail,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
