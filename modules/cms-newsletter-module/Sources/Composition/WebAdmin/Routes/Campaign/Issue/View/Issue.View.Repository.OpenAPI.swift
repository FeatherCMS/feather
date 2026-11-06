import NewsletterAdminAPI
import NewsletterModule

extension Issue.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model {
            try await Issue.Edit.Repository.OpenAPI(api: api)
                .get(newsletterId: newsletterId, issueId: issueId)
        }
    }
}
