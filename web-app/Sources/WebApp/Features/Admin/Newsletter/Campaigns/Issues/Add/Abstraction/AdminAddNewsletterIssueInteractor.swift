protocol AdminAddNewsletterIssueInteractor: Sendable {
    func getAddNewsletterIssue(newsletterId: String) async throws
        -> AdminAddNewsletterIssueModel
    func postAddNewsletterIssue(
        newsletterId: String,
        payload: NewsletterIssueAddForm
    ) async throws -> AdminAddNewsletterIssueModel
}
