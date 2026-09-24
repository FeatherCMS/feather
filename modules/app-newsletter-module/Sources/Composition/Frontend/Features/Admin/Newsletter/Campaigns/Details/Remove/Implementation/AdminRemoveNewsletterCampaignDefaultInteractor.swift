struct AdminRemoveNewsletterCampaignDefaultInteractor:
    AdminRemoveNewsletterCampaignInteractor
{
    let repository: AdminRemoveNewsletterCampaignOpenAPIRepository
    func remove(id: String) async throws { try await repository.remove(id: id) }
    func remove(ids: [String]) async throws {
        try await repository.remove(ids: ids)
    }
}
