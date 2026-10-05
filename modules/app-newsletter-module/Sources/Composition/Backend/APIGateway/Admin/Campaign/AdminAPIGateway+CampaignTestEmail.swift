import FeatherContracts
public import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterCampaignTestEmail(
        _ input: Operations.NewsletterCampaignTestEmail.Input
    ) async throws -> Operations.NewsletterCampaignTestEmail.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterIssueTestEmailSchema
        switch input.body {
        case .json(let value): body = value
        }
        try await useCases.makeSendNewsletterTestEmail()
            .execute(
                subject: subject,
                input: .init(
                    newsletterKey: input.path.newsletterCampaignKey,
                    email: body.email,
                    subject: body.subject,
                    content: body.content
                )
            )
        return .noContent
    }
}
