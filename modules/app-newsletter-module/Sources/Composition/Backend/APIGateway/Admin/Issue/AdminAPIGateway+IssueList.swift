import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueList(
        _ input: Operations.NewsletterIssueList.Input
    ) async throws -> Operations.NewsletterIssueList.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeListNewsletterIssues()
            .execute(
                subject: subject,
                input: .init(newsletterId: input.path.newsletterCampaignId)
            )
        return .ok(.init(body: .json(result.map(map))))
    }
}
