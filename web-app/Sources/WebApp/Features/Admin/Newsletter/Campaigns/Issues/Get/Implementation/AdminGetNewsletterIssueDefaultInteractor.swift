struct AdminGetNewsletterIssueDefaultInteractor:
    AdminGetNewsletterIssueInteractor
{
    let repository: AdminGetNewsletterIssueOpenAPIRepository
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    { try await repository.get(newsletterId: newsletterId, issueId: issueId) }
}
