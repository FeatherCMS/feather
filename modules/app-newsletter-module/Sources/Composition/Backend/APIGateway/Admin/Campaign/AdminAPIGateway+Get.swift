import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignGet(
        _ input: Operations.NewsletterCampaignGet.Input
    ) async throws -> Operations.NewsletterCampaignGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeGetNewsletterCampaign()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterCampaignId)
            )
        return .ok(.init(body: .json(map(result))))
    }
}
