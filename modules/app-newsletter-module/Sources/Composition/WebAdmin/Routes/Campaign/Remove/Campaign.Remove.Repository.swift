import NewsletterModule
import NewsletterApplication

extension Campaign.Remove.Repository {
    protocol Interface: Sendable {
        func remove(id: String) async throws

        func remove(ids: [String]) async throws
    }
}

extension Campaign.Remove {
    enum Repository {}
}
