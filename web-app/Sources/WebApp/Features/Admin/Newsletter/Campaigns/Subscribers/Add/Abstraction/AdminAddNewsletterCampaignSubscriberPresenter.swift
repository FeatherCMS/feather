import Hummingbird

protocol AdminAddNewsletterCampaignSubscriberPresenter: Sendable {
    func render(
        newsletterId: String,
        form: NewsletterSubscriberForm,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
