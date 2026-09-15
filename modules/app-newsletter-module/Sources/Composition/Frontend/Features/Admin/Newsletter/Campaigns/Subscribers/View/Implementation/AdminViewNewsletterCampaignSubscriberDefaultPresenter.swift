import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignSubscriberDefaultPresenter:
    AdminViewNewsletterCampaignSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        item: AdminNewsletterCampaignSubscriberItem,
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
                error: nil,
                editAction: nil
            )
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Campaign subscriber",
            content: view
        )
    }
}
