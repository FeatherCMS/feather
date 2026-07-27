import AdminOpenAPI
import Application
import ContactApplication
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterCreate(
        _ input: Operations.ContactNewsletterCreate.Input
    ) async throws -> Operations.ContactNewsletterCreate.Output {
        try await modules.newsletter.authorize(
            permission: NewsletterPermissions.Campaigns.create
        )
        let body: Components.Schemas.ContactNewsletterCreateSchema
        switch input.body {
        case let .json(value): body = value
        }

        let result = try await modules.newsletter.makeCreateNewsletter()
            .execute(.init(name: body.name, fromEmail: body.fromEmail))

        return .created(.init(body: .json(map(result))))
    }
}
