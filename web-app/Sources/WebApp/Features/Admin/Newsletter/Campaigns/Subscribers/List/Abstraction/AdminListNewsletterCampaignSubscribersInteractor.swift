protocol AdminListNewsletterCampaignSubscribersInteractor: Sendable {
    func list(newsletterId: String, search: String?) async throws
        -> [AdminNewsletterCampaignSubscriberItem]
}
