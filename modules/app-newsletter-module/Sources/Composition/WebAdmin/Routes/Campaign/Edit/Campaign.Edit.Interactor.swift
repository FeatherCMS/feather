import NewsletterApplication
import NewsletterModule

extension Campaign.Edit {
    enum Interactor {}
}

extension Campaign.Edit.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Campaign.Item
        func update(
            id: String,
            newKey: String,
            name: String,
            fromEmail: String
        ) async throws
    }
}
