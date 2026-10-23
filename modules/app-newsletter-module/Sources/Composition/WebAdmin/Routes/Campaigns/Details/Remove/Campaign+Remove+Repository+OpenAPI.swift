import NewsletterApplication
import NewsletterModule

extension Campaign.Remove {
    enum Repository {}
}

extension Campaign.Remove.Repository {
    struct OpenAPI {
        let api: API.Client

        func remove(id: String) async throws {
            try await Campaign.APIClient(api: api).remove(id: id)
        }

        func remove(ids: [String]) async throws {
            try await Campaign.APIClient(api: api).remove(ids: ids)
        }
    }
}
