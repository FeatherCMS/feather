import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterUpdate(_ input: Operations.ContactNewsletterUpdate.Input) async throws -> Operations.ContactNewsletterUpdate.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Campaigns.update)
        let body: Components.Schemas.ContactNewsletterPatchSchema
        switch input.body { case let .json(value): body = value }
        let result = try await modules.newsletter.makeUpdateNewsletter().execute(.init(id: input.path.contactNewsletterId, name: body.name ?? ""))
        return .ok(.init(body: .json(map(result))))
    }
}
