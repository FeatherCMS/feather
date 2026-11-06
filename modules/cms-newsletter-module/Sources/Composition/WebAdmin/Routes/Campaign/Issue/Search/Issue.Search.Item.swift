import NewsletterApplication
import NewsletterModule

extension Issue.Search {
    struct Item: Sendable {
        let id: String
        let subject: String
        let status: String
        let scheduledAt: String
        let createdAt: String
        let deliveries: [DeliveryItem]
    }
}
