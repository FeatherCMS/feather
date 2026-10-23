import FeatherWebAdmin
import NewsletterModule

extension Campaign.Search.Repository {
    protocol Interface: Sendable {
        func searchCampaigns(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model
    }
}
