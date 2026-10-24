import FeatherWebAdmin
import NewsletterModule
import NewsletterApplication

extension Campaign.Search {
    enum Interactor {}
}

extension Campaign.Search.Interactor {
    protocol Interface: Sendable {
        func searchCampaigns(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model
    }
}
