import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterSubscriberGet(
        _ input: Operations.NewsletterSubscriberGet.Input
    ) async throws -> Operations.NewsletterSubscriberGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeGetNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: input.path.email
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
