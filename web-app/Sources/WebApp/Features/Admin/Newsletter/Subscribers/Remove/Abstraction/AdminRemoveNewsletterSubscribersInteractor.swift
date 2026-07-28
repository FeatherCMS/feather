protocol AdminRemoveNewsletterSubscribersInteractor: Sendable {
    func remove(ids: [String], campaignId: String?) async throws
}
