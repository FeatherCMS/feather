import NewsletterModule

extension Campaign {
    struct Item: Sendable {
        let id: String
        let key: String
        let name: String
        let fromEmail: String
    }
}
