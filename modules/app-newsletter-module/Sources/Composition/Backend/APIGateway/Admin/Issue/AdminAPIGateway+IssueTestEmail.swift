import FeatherModuleKit
public import NewsletterAdminAPI
import NewsletterApplication

extension AdminAPIGateway {
    public func newsletterIssueTestEmail(
        _ input: Operations.NewsletterIssueTestEmail.Input
    ) async throws -> Operations.NewsletterIssueTestEmail.Output {
        let subject = try await CurrentSubject.require()
        let campaignKey = try await campaignKey(
            for: input.path.newsletterCampaignId,
            subject: subject
        )
        let body: Components.Schemas.NewsletterIssueTestEmailSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await self.useCases.makeDetailIssue()
            .execute(
                subject: subject,
                input: .init(
                    campaignKey: campaignKey,
                    id: input.path.newsletterIssueId
                )
            )
        try await useCases.makeSendTestEmail()
            .execute(
                subject: subject,
                input: .init(
                    newsletterKey: campaignKey,
                    email: body.email,
                    subject: body.subject,
                    content: body.content
                )
            )
        return .noContent
    }
}
