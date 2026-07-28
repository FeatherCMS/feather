struct AdminEditNewsletterIssueDefaultInteractor:
    AdminEditNewsletterIssueInteractor
{
    let repository: AdminEditNewsletterIssueOpenAPIRepository
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    { try await repository.get(newsletterId: newsletterId, issueId: issueId) }
    func update(
        newsletterId: String,
        issueId: String,
        form: NewsletterIssueAddForm
    ) async throws {
        try await repository.update(
            newsletterId: newsletterId,
            issueId: issueId,
            form: form
        )
    }
}
