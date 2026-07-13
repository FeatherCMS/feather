import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterGet(_ input: Operations.ContactNewsletterGet.Input) async throws -> Operations.ContactNewsletterGet.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Campaigns.read)
        let result = try await modules.newsletter.makeGetNewsletter().execute(.init(id: input.path.contactNewsletterId))
        return .ok(.init(body: .json(map(result))))
    }
}
