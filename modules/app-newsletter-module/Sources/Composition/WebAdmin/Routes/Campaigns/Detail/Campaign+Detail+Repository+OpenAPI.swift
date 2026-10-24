import NewsletterAdminAPI
import NewsletterApplication
import NewsletterModule

extension Campaign.Detail.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(id: String) async throws -> Campaign.Item {
            try await Campaign.API.Client(api: api).get(id: id)
        }
    }
}
