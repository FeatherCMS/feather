import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminGetNewsletterCampaignDefaultPresenter:
    AdminGetNewsletterCampaignPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Campaign details",
            description: "Manage campaign details",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterEdit(
                state: .init(
                    id: item.id,
                    isEdited: false,
                    form: .init(
                        name: item.name,
                        fromEmail: item.fromEmail,
                        error: error,
                        success: nil
                    ),
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                        .init(
                            label: "Details",
                            link: "/admin/newsletters/\(item.id)/details/"
                        ),
                    ])
                )
            )
        )
    }
}
