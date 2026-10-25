import FeatherWebAdmin
import NewsletterModule
import NewsletterApplication

extension Campaign.Search.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Search.Repository.Interface

        func searchCampaigns(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model {
            try await repository.search(page: page, search: search)
        }
    }
}
