import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterSubscriberList(_ input: Operations.ContactNewsletterSubscriberList.Input) async throws -> Operations.ContactNewsletterSubscriberList.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Subscribers.list)
        let result = try await modules.newsletter.makeListNewsletterSubscribers().execute(.init(newsletterId: input.path.contactNewsletterId))
        return .ok(.init(body: .json(result.map(map))))
    }
}
