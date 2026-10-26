import NewsletterModule
import NewsletterApplication

extension Issue.Add.Repository {
    protocol Interface: Sendable {
        func createIssue(
            newsletterId: String,
            form: Issue.Form.Input
        ) async throws
    }
}

extension Issue.Add {
    enum Repository {}
}
