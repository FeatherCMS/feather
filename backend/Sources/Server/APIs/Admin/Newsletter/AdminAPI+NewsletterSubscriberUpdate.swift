import AdminOpenAPI
import NewsletterDomain
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterSubscriberUpdate(_ input: Operations.ContactNewsletterSubscriberUpdate.Input) async throws -> Operations.ContactNewsletterSubscriberUpdate.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Subscribers.update)
        let body: Components.Schemas.ContactNewsletterSubscriberPatchSchema
        switch input.body { case let .json(value): body = value }
        let result = try await modules.newsletter.makeUpdateNewsletterSubscriber().execute(.init(newsletterId: input.path.contactNewsletterId, email: input.path.email, firstName: body.firstName ?? "", lastName: body.lastName ?? "", status: NewsletterCampaignSubscriber.Status(rawValue: body.status) ?? .subscribed))
        return .ok(.init(body: .json(map(result))))
    }
}
