protocol AdminRemoveNewsletterCampaignInteractor: Sendable {
    func remove(id: String) async throws
    func remove(ids: [String]) async throws
}
