import NewsletterModule
import NewsletterApplication

extension Campaign.Subscriber.Edit {
    enum Repository {}
}

extension Campaign.Subscriber.Edit.Repository {
    protocol Interface: Sendable {
        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item

        func update(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form.Input
        ) async throws
    }
}
