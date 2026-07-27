import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterTestEmail(
        _ input: Operations.ContactNewsletterTestEmail.Input
    ) async throws -> Operations.ContactNewsletterTestEmail.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Issues.update
        )
        let body: Components.Schemas.ContactNewsletterIssueTestEmailSchema
        switch input.body {
        case let .json(value): body = value
        }
        try await modules.newsletter.enqueueIssueTestEmail(
            newsletterId: input.path.contactNewsletterId,
            email: body.email,
            subject: body.subject,
            content: body.content
        )
        return .noContent
    }
}
