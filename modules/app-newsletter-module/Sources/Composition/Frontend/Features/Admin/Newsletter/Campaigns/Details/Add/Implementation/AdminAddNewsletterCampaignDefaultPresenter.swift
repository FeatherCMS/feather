import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignDefaultPresenter:
    AdminAddNewsletterCampaignPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletter/campaigns/"),
            .init(label: "Campaigns", link: "/admin/newsletter/campaigns/"),
        ])
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Add campaign",
            description: "Add campaign",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
