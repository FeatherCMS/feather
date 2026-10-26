import NewsletterModule

extension Subscriber.View {
    struct Model: Sendable {
        let id: String
        let email: String
        let name: String
        let newsletters: [Newsletter]
    }
}
