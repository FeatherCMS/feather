import Domain

public protocol NewsletterCampaignDeliveryRepository: Repository {

    func findBy(
        issueId: String,
        subscriberEmail: String
    ) async throws -> NewsletterCampaignDelivery?

    func insert(
        _ model: NewsletterCampaignDelivery.New
    ) async throws -> NewsletterCampaignDelivery

    func update(
        _ model: NewsletterCampaignDelivery
    ) async throws -> NewsletterCampaignDelivery
}
