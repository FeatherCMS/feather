import FeatherWebAdmin
import NewsletterApplication
import NewsletterModule

extension Issue.Remove {
    enum Interactor {}
}

extension Issue.Remove.Interactor {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            issueId: String
        ) async throws -> AdminRemoveItemContext

        func remove(newsletterId: String, issueIds: [String]) async throws
    }
}
