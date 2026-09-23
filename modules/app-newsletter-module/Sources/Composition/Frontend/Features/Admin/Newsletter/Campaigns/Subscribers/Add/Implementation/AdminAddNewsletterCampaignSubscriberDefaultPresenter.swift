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
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        newsletterId: String,
        form: NewsletterCampaignSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let view = NewsletterCampaignSubscriberFormView(
            state: .init(
                newsletterId: newsletterId,
                email: form.email,
                firstName: form.firstName,
                lastName: form.lastName,
                status: form.status,
                isEdit: false,
                error: error,
                editAction: nil
            )
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add campaign subscriber",
            content: view
        )
    }
}
