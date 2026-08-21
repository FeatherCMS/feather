import NewsletterAppAPI
import NewsletterApplication

extension AppAPIGateway {
    public func appNewsletterCampaignSubscribe(
        _ input: Operations.AppNewsletterCampaignSubscribe.Input
    ) async throws -> Operations.AppNewsletterCampaignSubscribe.Output {
        let body: Components.Schemas.AppNewsletterCampaignSubscriptionSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await self.useCases.makeSubscribeToNewsletter()
            .execute(
                .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: body.email,
                    firstName: body.firstName ?? "",
                    lastName: body.lastName ?? ""
                )
            )
        return .noContent
    }

    public func appNewsletterCampaignUnsubscribe(
        _ input: Operations.AppNewsletterCampaignUnsubscribe.Input
    ) async throws -> Operations.AppNewsletterCampaignUnsubscribe.Output {
        let body: Components.Schemas.AppNewsletterCampaignSubscriptionSchema
        switch input.body {
        case .json(let value): body = value
        }
        _ = try await self.useCases.makeUnsubscribeFromNewsletter()
            .execute(
                .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: body.email
                )
            )
        return .noContent
    }
}
