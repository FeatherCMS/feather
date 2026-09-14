import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminGetNewsletterCampaignSubscriberDefaultPresenter:
    AdminGetNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

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
                    .init(
                        label: "Campaigns",
                        link: "/admin/newsletter/campaigns/"
                    ),
                    .init(label: "Subscriber", link: ""),
                ]),
                editAction: nil
            )
        )
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Campaign subscriber",
            description: "View campaign subscriber",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
