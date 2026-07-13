import AdminOpenAPI
import NewsletterApplication

extension AdminAPI {
    func contactNewsletterList(_ input: Operations.ContactNewsletterList.Input) async throws -> Operations.ContactNewsletterList.Output {
        try await modules.newsletter.authorize(permission: NewsletterPermissions.Campaigns.list)
        let result = try await modules.newsletter.makeListNewsletters().execute(.init())
        return .ok(.init(body: .json(result.map(map))))
    }
}
