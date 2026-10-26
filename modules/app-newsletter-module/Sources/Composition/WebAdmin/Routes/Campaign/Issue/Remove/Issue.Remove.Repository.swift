import NewsletterApplication
import NewsletterModule

extension Issue.Remove.Repository {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model

        func remove(
            newsletterId: String,
            issueId: String
        ) async throws
    }
}

extension Issue.Remove {
    enum Repository {}
}
