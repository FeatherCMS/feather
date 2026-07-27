protocol AdminAddNewsletterCampaignSubscriberInteractor: Sendable {
    func create(newsletterId: String, form: NewsletterSubscriberForm)
        async throws
}
