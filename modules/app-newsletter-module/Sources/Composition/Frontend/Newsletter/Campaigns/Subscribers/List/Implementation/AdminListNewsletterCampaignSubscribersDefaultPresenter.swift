import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterCampaignSubscribersDefaultPresenter:
    AdminListNewsletterCampaignSubscribersPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        newsletterId: String,
        items: [AdminNewsletterCampaignSubscriberItem],
        search: String?,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let view = NewsletterCampaignSubscribersTable(
            state: .init(
                newsletterId: newsletterId,
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                items: items,
                search: search ?? "",
                canRemove: permissions.contains(
                    "newsletter:subscribers:delete"
                ),
                error: error,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Subscribers", link: ""),
                ])
            )
        )
        return renderEngine.renderAdminPage(
            request: request,
            title: "Campaign subscribers - Feather CMS",
            description: "Manage campaign subscribers",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
