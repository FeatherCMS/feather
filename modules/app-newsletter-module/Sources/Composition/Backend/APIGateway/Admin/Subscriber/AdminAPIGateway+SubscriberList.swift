import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterSubscriberList(
        _ input: Operations.NewsletterSubscriberList.Input
    ) async throws -> Operations.NewsletterSubscriberList.Output {
        let subject = try await CurrentSubject.require()
        let result =
            try await useCases
            .makeListNewsletterSubscribers()
            .execute(
                subject: subject,
                input: .init(newsletterId: input.path.newsletterCampaignId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
