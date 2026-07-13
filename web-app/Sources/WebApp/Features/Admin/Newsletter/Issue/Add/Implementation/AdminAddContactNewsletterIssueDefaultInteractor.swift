struct AdminAddContactNewsletterIssueDefaultInteractor: AdminAddContactNewsletterIssueInteractor {
    let repository: AdminAddContactNewsletterIssueOpenAPIRepository
    func getAddContactNewsletterIssue(newsletterId: String) async throws -> AdminAddContactNewsletterIssueModel { .init(subject: "", content: "", scheduledAt: "", newsletterId: newsletterId, error: nil) }
    func postAddContactNewsletterIssue(newsletterId: String, payload: ContactNewsletterIssueAddForm) async throws -> AdminAddContactNewsletterIssueModel {
        do { try await repository.createIssue(newsletterId: newsletterId, form: payload); return .init(subject: "", content: "", scheduledAt: "", newsletterId: newsletterId, error: nil) }
        catch let error as OpenAPIRepositoryError { return .init(subject: payload.subject, content: payload.content, scheduledAt: payload.scheduledAt, newsletterId: newsletterId, error: error.errorDescription) }
    }
}
