import NewsletterModule

extension Campaign.Subscriber.View {
    enum Interactor {}
}

extension Campaign.Subscriber.View.Interactor {
    protocol Interface: Sendable {
        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
    }
}
