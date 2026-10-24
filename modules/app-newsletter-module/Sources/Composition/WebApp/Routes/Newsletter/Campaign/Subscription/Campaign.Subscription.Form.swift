import NewsletterModule

extension Campaign.Subscription {
    struct Form: Decodable, Sendable {
        let email: String
        let nonce: String?
        let redirect: String?
    }
}
