import AdminOpenAPI
import NewsletterDomain
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterSubscriberCreate(
        _ input: Operations.ContactNewsletterSubscriberCreate.Input
    ) async throws -> Operations.ContactNewsletterSubscriberCreate.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Subscribers.create
        )
        let body: Components.Schemas.ContactNewsletterSubscriberCreateSchema
        switch input.body {
        case let .json(value): body = value
        }
        let status =
            NewsletterCampaignSubscriber.Status(
                rawValue: body.status ?? "subscribed"
            ) ?? .subscribed
        let result = try await modules.newsletter
            .makeCreateNewsletterSubscriber()
            .execute(
                .init(
                    newsletterId: input.path.contactNewsletterId,
                    email: body.email,
                    firstName: body.firstName ?? "",
                    lastName: body.lastName ?? "",
                    status: status
                )
            )
        return .created(.init(body: .json(map(result))))
    }
}
