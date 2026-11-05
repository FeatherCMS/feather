import NewsletterModule

extension Campaign.Subscriber.List {
    struct Result: Sendable {
        let items: [Item]
        let total: Int
    }
}
