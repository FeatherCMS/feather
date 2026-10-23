import NewsletterModule

extension Campaign.Subscriber.Edit {
    enum Interactor {}
}

extension Campaign.Subscriber.Edit.Interactor {
    protocol Interface: Sendable {
        func get(
            newsletterId: String,
            subscriberId: String
        ) async throws -> Campaign.Subscriber.Item

        func update(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form
        ) async throws
    }
}
