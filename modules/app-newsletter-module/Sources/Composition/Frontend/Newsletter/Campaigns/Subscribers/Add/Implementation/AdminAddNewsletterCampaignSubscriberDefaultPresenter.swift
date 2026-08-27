import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterCampaignSubscriberDefaultPresenter:
    AdminAddNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        newsletterId: String,
        form: NewsletterCampaignSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        let view = NewsletterCampaignSubscriberFormView(
            state: .init(
                newsletterId: newsletterId,
                email: form.email,
                firstName: form.firstName,
                lastName: form.lastName,
                status: form.status,
                isEdit: false,
                error: error,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Add", link: ""),
                ]),
                editAction: nil
            )
        )
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add campaign subscriber - Feather CMS",
            description: "Add campaign subscriber",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
