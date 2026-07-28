protocol AdminAddNewsletterCampaignInteractor: Sendable {
    func getAddNewsletterCampaign() async throws
        -> AdminAddNewsletterCampaignModel
    func postAddNewsletterCampaign(payload: NewsletterCampaignAddForm)
        async throws -> AdminAddNewsletterCampaignModel
}
