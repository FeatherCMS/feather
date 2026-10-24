import NewsletterModule

extension Issue.View.Interactor {
    struct Default: Interface {
        let repository: Issue.View.Repository.OpenAPI

        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model {
            try await repository.get(
                newsletterId: newsletterId,
                issueId: issueId
            )
        }
    }
}
