import NewsletterApplication
import NewsletterModule

extension Campaign.Detail {
    enum Interactor {}
}

extension Campaign.Detail.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Campaign.Item
    }
}
