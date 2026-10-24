import NewsletterModule

extension Campaign.Search {
    enum Repository {}
}

extension Campaign.Search.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func searchCampaigns(
            page: Int,
            search: String?
        ) async throws -> Campaign.Search.Model {
            try await Campaign.API.Client(api: api)
                .search(
                    page: page,
                    search: search
                )
        }
    }
}
