import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterIssueDelete(
        _ input: Operations.ContactNewsletterIssueDelete.Input
    ) async throws -> Operations.ContactNewsletterIssueDelete.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Issues.delete)
        try await modules.newsletter.makeDeleteNewsletterIssue().execute(
            .init(id: input.path.contactNewsletterIssueId)
        )
        return .noContent
    }
}
