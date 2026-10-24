import NewsletterModule

extension Subscriber.View {
    enum Repository {}
}

extension Subscriber.View.Repository {
    protocol Interface: Sendable {
        func get(id: String) async throws -> Subscriber.View.Model
    }
}
