protocol AdminEditNewsletterIssueInteractor: Sendable {
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    func update(
        newsletterId: String,
        issueId: String,
        form: NewsletterIssueAddForm
    ) async throws
}
