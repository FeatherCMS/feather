import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterSubscriberGet(
        _ input: Operations.ContactNewsletterSubscriberGet.Input
    ) async throws -> Operations.ContactNewsletterSubscriberGet.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Subscribers.read
        )
        let result = try await modules.newsletter.makeGetNewsletterSubscriber()
            .execute(
                .init(
                    newsletterId: input.path.contactNewsletterId,
                    email: input.path.email
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
