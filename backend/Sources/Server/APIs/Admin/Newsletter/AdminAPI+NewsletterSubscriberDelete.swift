import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterSubscriberDelete(_ input: Operations.ContactNewsletterSubscriberDelete.Input) async throws -> Operations.ContactNewsletterSubscriberDelete.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Subscribers.delete)
        try await modules.newsletter.makeDeleteNewsletterSubscriber().execute(.init(newsletterId: input.path.contactNewsletterId, email: input.path.email))
        return .noContent
    }
}
