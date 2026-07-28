import Hummingbird

protocol AdminRemoveNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        subscriberId: String,
        email: String,
        permissions: Set<String>
    ) -> HTMLResponse
}
