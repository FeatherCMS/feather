import NewsletterModule

extension Issue.View {
    enum Interactor {}
}

extension Issue.View.Interactor {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> Issue.Form.Model
    }
}
