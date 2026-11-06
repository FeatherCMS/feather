import NewsletterModule

extension Campaign.Subscriber.Import {
    struct Result: Sendable {
        let imported: Int
        let skipped: Int
    }
}
