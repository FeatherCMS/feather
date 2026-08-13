import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminGetNewsletterCampaignSubscriberDefaultPresenter:
    AdminGetNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
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
                error: nil,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Subscriber", link: ""),
                ]),
                editAction: nil
            )
        )
        return renderEngine.renderAdminPage(
            request: request,
            title: "Campaign subscriber - Feather CMS",
            description: "View campaign subscriber",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
