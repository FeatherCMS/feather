import NewsletterModule

extension Campaign.Subscriber.Import {
    enum Interactor {}
}

extension Campaign.Subscriber.Import.Interactor {
    protocol Interface: Sendable {
        func run(
            newsletterId: String,
            csv: String
        ) async throws -> Campaign.Subscriber.Import.Result
    }
}
