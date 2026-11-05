import NewsletterModule

extension Campaign.Subscriber {
    struct Item: Sendable {
        let id: String
        let email: String
        let firstName: String
        let lastName: String
        let status: String
    }
}
