import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterDelete(
        _ input: Operations.ContactNewsletterDelete.Input
    ) async throws -> Operations.ContactNewsletterDelete.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Campaigns.delete
        )
        _ = try await modules.newsletter.makeDeleteNewsletter()
            .execute(.init(id: input.path.contactNewsletterId))
        return .noContent
    }
}
