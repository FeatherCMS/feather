import NewsletterModule

extension Campaign.Subscriber {
    enum Form {}
}

extension Campaign.Subscriber.Form {
    struct Input: Decodable, Sendable {
        let email: String
        let firstName: String
        let lastName: String
        let status: String
    }
}
