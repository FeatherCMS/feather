import FeatherAdmin
import Hummingbird

struct AdminAddNewsletterCampaignDefaultPresenter:
    AdminAddNewsletterCampaignPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add campaign",
            content: NewsletterCampaignAddView(
                state: .init(
                    name: model.name,
                    fromEmail: model.fromEmail,
                    error: model.error
                )
            )
        )
    }
}
