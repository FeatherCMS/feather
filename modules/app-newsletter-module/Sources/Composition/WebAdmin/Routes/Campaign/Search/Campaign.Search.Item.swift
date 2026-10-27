import NewsletterApplication
import NewsletterModule

extension Campaign.Search {
    struct Item: Sendable {
        let id: String
        let name: String
        let fromEmail: String
        let subscriberCount: Int
        let sentIssueCount: Int
    }
}
