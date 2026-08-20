import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterSubscriberDelete(
        _ input: Operations.NewsletterSubscriberDelete.Input
    ) async throws -> Operations.NewsletterSubscriberDelete.Output {
        let subject = try await CurrentSubject.require()
        try await self.useCases.makeDeleteNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: input.path.email
                )
            )
        return .noContent
    }
}
