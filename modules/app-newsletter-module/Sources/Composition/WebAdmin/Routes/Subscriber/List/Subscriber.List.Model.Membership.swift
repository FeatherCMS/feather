import NewsletterModule
import NewsletterApplication

extension Subscriber.List.Model {
    struct Membership: Sendable {
        let id: String
        let name: String
        let status: String
    }
}
