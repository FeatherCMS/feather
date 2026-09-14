import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignsDefaultPresenter:
    AdminListNewsletterCampaignsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

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
        renderingEngine.renderAdminPage(
            request: request,
            title: "Campaigns",
            description: "Manage campaigns",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
                        .init(
                            label: "Campaigns",
                            link: "/admin/newsletter/campaigns/"
                        ),
                    ])
                )
            )
        )
    }
}
