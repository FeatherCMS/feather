import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignSubscriberDefaultPresenter:
    AdminEditNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
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
                    .init(
                        label: "Campaigns",
                        link: "/admin/newsletter/campaigns/"
                    ),
                    .init(label: "Edit", link: ""),
                ]),
                editAction: nil
            )
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit campaign subscriber",
            content: view
        )
    }
}
