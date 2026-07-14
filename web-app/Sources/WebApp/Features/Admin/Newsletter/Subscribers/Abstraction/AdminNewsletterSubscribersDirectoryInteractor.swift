protocol AdminNewsletterSubscribersDirectoryInteractor: Sendable {
    func list(
        search: String?,
        campaignId: String?
    ) async throws -> AdminNewsletterSubscribersDirectoryModel
    func bulkRemove(subscriberIds: [String], campaignId: String?) async throws
}
