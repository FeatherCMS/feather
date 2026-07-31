protocol AdminListNewsletterSubscribersInteractor: Sendable {
    func list(search: String?, campaignId: String?) async throws
        -> AdminNewsletterSubscribersListModel
}
