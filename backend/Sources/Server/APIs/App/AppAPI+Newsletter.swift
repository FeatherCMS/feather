import AppOpenAPI
import NewsletterApplication

extension AppAPI {
    func appContactNewsletterSubscribe(
        _ input: Operations.AppContactNewsletterSubscribe.Input
    ) async throws -> Operations.AppContactNewsletterSubscribe.Output {
        let body: Components.Schemas.AppContactNewsletterSubscriptionSchema
        switch input.body {
        case let .json(value): body = value
        }
        _ = try await modules.newsletter.makeSubscribeToNewsletter().execute(.init(newsletterId: input.path.contactNewsletterId, email: body.email, firstName: body.firstName ?? "", lastName: body.lastName ?? ""))
        return .noContent
    }

    func appContactNewsletterUnsubscribe(
        _ input: Operations.AppContactNewsletterUnsubscribe.Input
    ) async throws -> Operations.AppContactNewsletterUnsubscribe.Output {
        let body: Components.Schemas.AppContactNewsletterSubscriptionSchema
        switch input.body {
        case let .json(value): body = value
        }
        _ = try await modules.newsletter.makeUnsubscribeFromNewsletter().execute(.init(newsletterId: input.path.contactNewsletterId, email: body.email))
        return .noContent
    }
}
