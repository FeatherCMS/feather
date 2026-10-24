import NewsletterApplication
import NewsletterModule

extension Campaign.Detail {
    enum Repository {}
}

extension Campaign.Detail.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Campaign.Item
    }
}
