import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterIssueTestEmail(
        _ input: Operations.ContactNewsletterIssueTestEmail.Input
    ) async throws -> Operations.ContactNewsletterIssueTestEmail.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Issues.update
        )
        let body: Components.Schemas.ContactNewsletterIssueTestEmailSchema
        switch input.body {
        case let .json(value): body = value
        }
        let issue = try await modules.newsletter.makeGetNewsletterIssue()
            .execute(
                .init(id: input.path.contactNewsletterIssueId)
            )
        try await modules.newsletter.enqueueIssueTestEmail(
            issue: issue,
            email: body.email
        )
        return .noContent
    }
}
