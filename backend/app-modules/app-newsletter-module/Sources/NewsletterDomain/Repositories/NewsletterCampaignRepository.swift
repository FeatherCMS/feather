import Domain

public protocol NewsletterCampaignRepository: Repository {

    func list() async throws -> [NewsletterCampaign]

    func findBy(
        id: String
    ) async throws -> NewsletterCampaign?

    func insert(
        _ model: NewsletterCampaign.New
    ) async throws -> NewsletterCampaign

    func update(
        _ model: NewsletterCampaign
    ) async throws -> NewsletterCampaign

    func delete(
        id: String
    ) async throws -> Bool
}
