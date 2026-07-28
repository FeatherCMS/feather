import AdminOpenAPI

struct AdminAddNewsletterCampaignSubscriberOpenAPIRepository {
    let api: AdminAPI
    func create(newsletterId: String, form: NewsletterSubscriberForm)
        async throws
    {
        try await AdminNewsletterCampaignSubscribersAPIClient(api: api)
            .create(newsletterId: newsletterId, form: form)
    }
}
