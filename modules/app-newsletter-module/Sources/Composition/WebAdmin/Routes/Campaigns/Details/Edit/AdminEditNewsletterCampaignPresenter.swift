import FeatherWebAdmin
import NewsletterModule

protocol AdminEditNewsletterCampaignPresenter: Sendable {
    func render(
        item: Campaign.Item,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderEditError(
        id: String,
        item: Campaign.Item,
        error: AdminEditNewsletterCampaignError,
        permissions: Set<String>
    ) async throws -> HTMLResponse

    func renderErrorPage(
        error: AdminEditNewsletterCampaignError
    ) async throws -> HTMLResponse
}
