protocol AdminAddContactNewsletterIssueInteractor: Sendable {
    func getAddContactNewsletterIssue(newsletterId: String) async throws
        -> AdminAddContactNewsletterIssueModel
    func postAddContactNewsletterIssue(
        newsletterId: String,
        payload: ContactNewsletterIssueAddForm
    ) async throws -> AdminAddContactNewsletterIssueModel
}
