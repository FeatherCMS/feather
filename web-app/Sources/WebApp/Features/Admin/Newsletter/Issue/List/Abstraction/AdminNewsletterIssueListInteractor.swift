protocol AdminNewsletterIssueListInteractor: Sendable {
    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueListItem]
}
