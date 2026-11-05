import NewsletterModule

extension Campaign.Subscriber.Import {
    struct Form: Decodable, Sendable {
        let csv: String
    }
}
