import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterIssueDeliveryList(
        _ input: Operations.ContactNewsletterIssueDeliveryList.Input
    ) async throws -> Operations.ContactNewsletterIssueDeliveryList.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Issues.read)
        let result = try await modules.newsletter.makeListNewsletterDeliveries().execute(
            .init(issueId: input.path.contactNewsletterIssueId)
        )
        return .ok(.init(body: .json(result.map(map))))
    }
}
