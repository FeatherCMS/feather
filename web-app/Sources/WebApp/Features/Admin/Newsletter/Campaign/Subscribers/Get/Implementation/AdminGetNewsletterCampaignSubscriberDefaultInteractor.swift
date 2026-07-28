struct AdminGetNewsletterCampaignSubscriberDefaultInteractor:
    AdminGetNewsletterCampaignSubscriberInteractor
{
    let repository: AdminGetNewsletterCampaignSubscriberOpenAPIRepository
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminNewsletterCampaignSubscriberItem
    {
        try await repository.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
}
