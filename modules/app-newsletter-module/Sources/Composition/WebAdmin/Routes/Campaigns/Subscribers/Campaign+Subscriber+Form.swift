import NewsletterModule

extension Campaign.Subscriber {
    struct Form: Decodable, Sendable {
        let email: String
        let firstName: String
        let lastName: String
        let status: String
    }
}
