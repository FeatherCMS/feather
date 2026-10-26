import NewsletterApplication
import NewsletterModule

extension Campaign.Subscriber.View {
    enum Repository {}
}

extension Campaign.Subscriber.View.Repository {
    protocol Interface: Sendable {
        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
    }
}
