import AdminOpenAPI

struct AdminGetNewsletterIssueOpenAPIRepository {
    let api: AdminAPI
    func get(newsletterId: String, issueId: String) async throws
        -> AdminAddNewsletterIssueModel
    {
        try await AdminEditNewsletterIssueOpenAPIRepository(api: api)
            .get(newsletterId: newsletterId, issueId: issueId)
    }
}
