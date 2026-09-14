import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterCampaignSubscriberDefaultPresenter:
    AdminAddNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

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
                    .init(
                        label: "Campaigns",
                        link: "/admin/newsletter/campaigns/"
                    ),
                    .init(label: "Add", link: ""),
                ]),
                editAction: nil
            )
        )
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Add campaign subscriber",
            description: "Add campaign subscriber",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: view
        )
    }
}
