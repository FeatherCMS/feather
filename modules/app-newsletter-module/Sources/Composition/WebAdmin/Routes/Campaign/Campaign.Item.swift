import NewsletterModule

extension Campaign {
    struct Item: Sendable {
        let id: String
        let name: String
        let fromEmail: String
    }
}
