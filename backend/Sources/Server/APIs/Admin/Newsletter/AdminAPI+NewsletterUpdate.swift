import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterUpdate(
        _ input: Operations.ContactNewsletterUpdate.Input
    ) async throws -> Operations.ContactNewsletterUpdate.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Campaigns.update
        )
        let body: Components.Schemas.ContactNewsletterPatchSchema
        switch input.body {
        case let .json(value): body = value
        }
        let current = try await modules.newsletter.makeGetNewsletter()
            .execute(.init(id: input.path.contactNewsletterId))
        let result = try await modules.newsletter.makeUpdateNewsletter()
            .execute(
                .init(
                    id: current.id,
                    name: body.name ?? current.name,
                    fromEmail: body.fromEmail ?? current.fromEmail
                )
            )
        return .ok(.init(body: .json(map(result))))
    }
}
