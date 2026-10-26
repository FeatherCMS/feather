import NewsletterModule

extension Subscriber.View {
    enum Interactor {}
}

extension Subscriber.View.Interactor {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Subscriber.View.Model
    }
}
