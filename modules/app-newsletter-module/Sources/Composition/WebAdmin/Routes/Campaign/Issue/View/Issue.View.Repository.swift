import NewsletterModule
import NewsletterApplication

extension Issue.View.Repository {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model
    }
}

extension Issue.View {
    enum Repository {}
}
