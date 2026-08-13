import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension NewsletterBackend {
    public func newsletterCampaignDelete(
        _ input: Operations.NewsletterCampaignDelete.Input
    ) async throws -> Operations.NewsletterCampaignDelete.Output {
        let subject = try await CurrentSubject.require()
        _ = try await self.makeDeleteNewsletterCampaign()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterCampaignId)
            )
        return .noContent
    }
}
