import Hummingbird

protocol AdminRemoveNewsletterCampaignPresenter: Sendable {
    func render(id: String, permissions: Set<String>) -> HTMLResponse
}
