import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminListNewsletterCampaignsDefaultPresenter:
    AdminListNewsletterCampaignsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        items: [AdminNewsletterCampaignItem],
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        isPicker: Bool,
        error: String?,
        permissions: Set<String>,
        search: String
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Campaigns",
            description: "Manage campaigns",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterTable(
                state: .init(
                    isAdded: isAdded,
                    isEdited: isEdited,
                    isRemoved: isRemoved,
                    items: items,
                    search: search,
                    permissions: permissions,
                    isPicker: isPicker,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                    ])
                )
            )
        )
    }
}
