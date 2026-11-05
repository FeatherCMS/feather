import NewsletterApplication
import NewsletterModule

extension Issue.Edit {
    enum Interactor {}
}

extension Issue.Edit.Interactor {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model

        func edit(
            newsletterId: String,
            issueId: String,
            form: Issue.Form.Input
        ) async throws
    }
}
