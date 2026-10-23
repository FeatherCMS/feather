import NewsletterModule

extension Campaign.Subscriber.List {
    enum Repository {}
}

extension Campaign.Subscriber.List.Repository {
    protocol Interface: Sendable {
        func list(newsletterId: String) async throws
            -> [Campaign.Subscriber.Item]
    }
}
