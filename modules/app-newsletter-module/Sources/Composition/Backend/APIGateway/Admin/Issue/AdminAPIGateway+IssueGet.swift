import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueGet(
        _ input: Operations.NewsletterIssueGet.Input
    ) async throws -> Operations.NewsletterIssueGet.Output {
        let subject = try await CurrentSubject.require()
        let result = try await self.useCases.makeGetNewsletterIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: input.path.newsletterCampaignKey,
                    id: input.path.newsletterIssueId
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
