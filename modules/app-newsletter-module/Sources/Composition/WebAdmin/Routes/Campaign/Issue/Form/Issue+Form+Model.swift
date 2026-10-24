import NewsletterModule

extension Issue {
    enum Form {}
}

extension Issue.Form {
    struct Model: Sendable {
        let subject: String
        let content: String
        let scheduledAt: String
        let newsletterId: String
        let error: String?
    }
}
