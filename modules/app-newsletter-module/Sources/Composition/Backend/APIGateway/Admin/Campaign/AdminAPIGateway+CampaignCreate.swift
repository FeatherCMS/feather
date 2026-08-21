import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignCreate(
        _ input: Operations.NewsletterCampaignCreate.Input
    ) async throws -> Operations.NewsletterCampaignCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterCampaignCreateSchema
        switch input.body {
        case .json(let value): body = value
        }

        let result = try await self.useCases.makeCreateNewsletterCampaign()
            .execute(
                subject: subject,
                input: .init(name: body.name, fromEmail: body.fromEmail)
            )

        return .created(.init(body: .json(map(result))))
    }
}
