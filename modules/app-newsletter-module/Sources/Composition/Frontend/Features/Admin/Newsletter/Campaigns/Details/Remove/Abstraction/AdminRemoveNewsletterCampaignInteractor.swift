protocol AdminRemoveNewsletterCampaignInteractor: Sendable {
    func names(ids: [String]) async throws -> [String]
    func remove(id: String) async throws
    func remove(ids: [String]) async throws
}
