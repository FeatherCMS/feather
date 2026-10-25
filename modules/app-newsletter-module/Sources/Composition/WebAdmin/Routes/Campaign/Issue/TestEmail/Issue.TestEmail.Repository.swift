import FeatherWebShared
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    enum Repository {}
}

extension Issue.TestEmail.Repository {
    protocol Interface: Sendable {
        func send(
            newsletterKey: String,
            issueID: String?,
            email: String,
            subject: String,
            content: String
        ) async throws
    }
}
