import NewsletterModule

extension Issue.View.Repository {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model
    }
}
