import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListNewsletterCampaignSubscribersDefaultPresenter:
    AdminListNewsletterCampaignSubscribersPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

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
                    .init(
                        label: "Campaigns",
                        link: "/admin/newsletter/campaigns/"
                    ),
                    .init(label: "Subscribers", link: ""),
                ])
            )
        )
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Campaign subscribers",
            description: "Manage campaign subscribers",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
