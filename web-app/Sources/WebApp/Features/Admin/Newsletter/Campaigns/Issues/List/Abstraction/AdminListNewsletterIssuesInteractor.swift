protocol AdminListNewsletterIssuesInteractor: Sendable {
    func list(newsletterId: String) async throws
        -> [AdminNewsletterIssueItem]
}
