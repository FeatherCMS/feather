import FeatherWebShared

extension Issue.TestEmail {
    enum Repository {
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
}
