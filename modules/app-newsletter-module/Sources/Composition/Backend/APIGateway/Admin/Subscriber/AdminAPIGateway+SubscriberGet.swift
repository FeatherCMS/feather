import FeatherContracts
public import NewsletterAdminAPI
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
                    campaignKey: input.path.newsletterCampaignKey,
                    email: input.path.email
                )
            )
        return .ok(
            .init(
                body: .json(
                    map(result, campaignKey: input.path.newsletterCampaignKey)
                )
            )
        )
    }
}
