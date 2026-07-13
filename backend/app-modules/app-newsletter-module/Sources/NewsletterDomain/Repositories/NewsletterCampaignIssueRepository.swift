import Domain

public protocol NewsletterCampaignIssueRepository: Repository {

    func list(
        newsletterId: String
    ) async throws -> [NewsletterCampaignIssue]

    func findBy(
        id: String
    ) async throws -> NewsletterCampaignIssue?

    func insert(
        _ model: NewsletterCampaignIssue.New
    ) async throws -> NewsletterCampaignIssue

    func update(
        _ model: NewsletterCampaignIssue
    ) async throws -> NewsletterCampaignIssue
}
