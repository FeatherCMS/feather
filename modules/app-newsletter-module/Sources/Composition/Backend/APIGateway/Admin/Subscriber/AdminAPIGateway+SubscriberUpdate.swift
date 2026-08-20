import FeatherApplication
import FeatherContracts
import NewsletterAdminAPI
import NewsletterApplication
import NewsletterDomain

extension AdminAPIGateway {
    public func newsletterSubscriberUpdate(
        _ input: Operations.NewsletterSubscriberUpdate.Input
    ) async throws -> Operations.NewsletterSubscriberUpdate.Output {
        let subject = try await CurrentSubject.require()
        let body: Components.Schemas.NewsletterSubscriberPatchSchema
        switch input.body {
        case .json(let value): body = value
        }
        let result =
            try await useCases
            .makeUpdateNewsletterSubscriber()
            .execute(
                subject: subject,
                input: .init(
                    newsletterId: input.path.newsletterCampaignId,
                    email: input.path.email,
                    firstName: body.firstName ?? "",
                    lastName: body.lastName ?? "",
                    status: Subscriber.Status(
                        rawValue: body.status
                    ) ?? .subscribed
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
