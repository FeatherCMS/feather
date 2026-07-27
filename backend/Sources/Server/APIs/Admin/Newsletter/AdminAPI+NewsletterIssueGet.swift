import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterIssueGet(
        _ input: Operations.ContactNewsletterIssueGet.Input
    ) async throws -> Operations.ContactNewsletterIssueGet.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Issues.read)
        let result = try await modules.newsletter.makeGetNewsletterIssue().execute(
            .init(id: input.path.contactNewsletterIssueId)
        )
        return .ok(.init(body: .json(map(result))))
    }
}
