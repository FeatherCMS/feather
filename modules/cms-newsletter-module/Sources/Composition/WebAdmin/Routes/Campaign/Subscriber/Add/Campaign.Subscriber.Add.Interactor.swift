import NewsletterModule

extension Campaign.Subscriber.Add {
    enum Interactor {}
}

extension Campaign.Subscriber.Add.Interactor {
    protocol Interface: Sendable {
        func create(
            newsletterId: String,
            form: Campaign.Subscriber.Form.Input
        ) async throws
    }
}
