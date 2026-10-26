import NewsletterApplication
import NewsletterModule

extension Campaign.Remove {
    enum Interactor {}
}

extension Campaign.Remove.Interactor {
    protocol Interface: Sendable {
        func remove(id: String) async throws
        func remove(ids: [String]) async throws
    }
}
