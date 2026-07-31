import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterIssueList(
        _ input: Operations.ContactNewsletterIssueList.Input
    ) async throws -> Operations.ContactNewsletterIssueList.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Issues.list
        )
        let result = try await modules.newsletter.makeListNewsletterIssues()
            .execute(
                .init(newsletterId: input.path.contactNewsletterId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
