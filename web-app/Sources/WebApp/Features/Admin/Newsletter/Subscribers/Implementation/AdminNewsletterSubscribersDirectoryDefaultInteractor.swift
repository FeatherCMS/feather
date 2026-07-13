struct AdminNewsletterSubscribersDirectoryDefaultInteractor: AdminNewsletterSubscribersDirectoryInteractor {
    let repository: AdminNewsletterSubscribersDirectoryOpenAPIRepository

    func list(
        search: String?,
        campaignId: String?
    ) async throws -> AdminNewsletterSubscribersDirectoryModel {
        let campaigns = try await repository.campaigns()
        let items = try await repository.list()
        let normalizedSearch = search?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let filteredItems = items.filter { item in
            let matchesSearch = normalizedSearch.isEmpty
                || item.email.localizedCaseInsensitiveContains(normalizedSearch)
                || item.name.localizedCaseInsensitiveContains(normalizedSearch)
            let matchesCampaign = campaignId?.isEmpty != false
                || item.newsletters.contains { $0.id == campaignId }
            return matchesSearch && matchesCampaign
        }
        return .init(items: filteredItems, campaigns: campaigns, search: normalizedSearch, campaignId: campaignId ?? "")
    }
}
