import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension NewsletterBackend {
    public func newsletterSubscriberCreate(
        _ input: Operations.NewsletterSubscriberCreate.Input
    ) async throws -> Operations.NewsletterSubscriberCreate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterSubscriberCreateSchema
        switch input.body {
        case .json(let value): body = value
        }
        let status =
            Subscriber.Status(
                rawValue: body.status ?? "subscribed"
            ) ?? .subscribed
        let result =
            try await self
            .makeCreateNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: body.email,
                    firstName: body.firstName ?? "",
                    lastName: body.lastName ?? "",
                    status: status
                )
            )
        return .created(.init(body: .json(map(result))))
    }
}
