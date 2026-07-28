import Domain

public protocol NewsletterCampaignSubscriberRepository: Repository {

    func list(
        newsletterId: String
    ) async throws -> [NewsletterCampaignSubscriber]

    func findBy(
        newsletterId: String,
        email: String
    ) async throws -> NewsletterCampaignSubscriber?

    func insert(
        _ model: NewsletterCampaignSubscriber.New
    ) async throws -> NewsletterCampaignSubscriber

    func update(
        _ model: NewsletterCampaignSubscriber
    ) async throws -> NewsletterCampaignSubscriber

    func delete(
        newsletterId: String,
        email: String
    ) async throws -> Bool
}
