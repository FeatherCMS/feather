import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminEditNewsletterCampaignSubscriberDefaultPresenter:
    AdminEditNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let view = NewsletterCampaignSubscriberFormView(
            state: .init(
                newsletterId: newsletterId,
                email: item.email,
                firstName: item.firstName,
                lastName: item.lastName,
                status: item.status,
                isEdit: true,
                error: error,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Edit", link: ""),
                ]),
                editAction: nil
            )
        )
        return renderEngine.renderAdminPage(
            request: request,
            title: "Edit campaign subscriber",
            description: "Edit campaign subscriber",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
