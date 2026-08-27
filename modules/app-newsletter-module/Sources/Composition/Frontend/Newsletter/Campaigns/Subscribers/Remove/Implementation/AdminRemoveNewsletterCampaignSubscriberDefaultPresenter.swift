import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveNewsletterCampaignSubscriberDefaultPresenter:
    AdminRemoveNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func render(
        newsletterId: String,
        subscriberId: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove campaign subscriber - Feather CMS",
            description: "Remove campaign subscriber",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterCampaignSubscriberRemoveView(
                email: email,
                subscriberId: subscriberId,
                newsletterId: newsletterId,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Remove", link: ""),
                ])
            )
        )
    }
}
