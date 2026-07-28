struct AdminAddNewsletterCampaignSubscriberDefaultInteractor:
    AdminAddNewsletterCampaignSubscriberInteractor
{
    let repository: AdminAddNewsletterCampaignSubscriberOpenAPIRepository
    func create(newsletterId: String, form: NewsletterSubscriberForm)
        async throws
    { try await repository.create(newsletterId: newsletterId, form: form) }
}
