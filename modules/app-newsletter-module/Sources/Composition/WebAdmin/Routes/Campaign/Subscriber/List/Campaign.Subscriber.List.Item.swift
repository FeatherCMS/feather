import NewsletterModule

extension Campaign.Subscriber.List {
    struct Item: Sendable {
        let id: String
        let email: String
        let name: String
        let status: String
    }
}
