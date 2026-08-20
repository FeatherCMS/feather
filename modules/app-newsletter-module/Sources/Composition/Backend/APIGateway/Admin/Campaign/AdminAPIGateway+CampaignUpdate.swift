import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignUpdate(
        _ input: Operations.NewsletterCampaignUpdate.Input
    ) async throws -> Operations.NewsletterCampaignUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterCampaignPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let current = try await self.useCases.makeGetNewsletterCampaign()
            .execute(
                subject: subject,
                input: .init(id: input.path.newsletterCampaignId)
            )
        let result = try await self.useCases.makeUpdateNewsletterCampaign()
            .execute(
                subject: subject,
                input: .init(
                    id: current.id,
                    name: body.name ?? current.name,
                    fromEmail: body.fromEmail ?? current.fromEmail
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
