import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignList(
        _ input: Operations.NewsletterCampaignList.Input
    ) async throws -> Operations.NewsletterCampaignList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListNewsletterCampaigns()
            .execute(subject: subject, input: .init())
        return .ok(.init(body: .json(result.map(map))))
    }
}
