protocol AdminRemoveNewsletterIssueInteractor: Sendable {
    func remove(newsletterId: String, issueId: String) async throws
}
