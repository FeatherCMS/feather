import FeatherWebAdmin
import NewsletterModule

protocol AdminViewNewsletterCampaignPresenter: Sendable {
    func render(
        item: Campaign.Item,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
