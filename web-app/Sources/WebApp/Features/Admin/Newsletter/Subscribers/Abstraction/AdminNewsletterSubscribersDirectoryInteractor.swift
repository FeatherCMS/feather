protocol AdminNewsletterSubscribersDirectoryInteractor: Sendable {
    func list(
        search: String?,
        campaignId: String?
    ) async throws -> AdminNewsletterSubscribersDirectoryModel
}
