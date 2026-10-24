import NewsletterModule

extension Subscriber.View.Model {
    struct Newsletter: Sendable {
        let id: String
        let name: String
        let status: String
    }
}
