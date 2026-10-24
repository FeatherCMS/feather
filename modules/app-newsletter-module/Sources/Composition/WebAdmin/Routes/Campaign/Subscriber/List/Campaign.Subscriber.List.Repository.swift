import NewsletterModule

extension Campaign.Subscriber.List {
    enum Repository {}
}

extension Campaign.Subscriber.List.Repository {
    protocol Interface: Sendable {
        func search(
            newsletterId: String,
            search: String?,
            page: Int
        ) async throws -> Campaign.Subscriber.List.Result
    }
}
