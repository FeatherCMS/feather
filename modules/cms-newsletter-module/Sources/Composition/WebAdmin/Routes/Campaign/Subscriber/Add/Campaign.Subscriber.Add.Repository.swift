import NewsletterApplication
import NewsletterModule

extension Campaign.Subscriber.Add {
    enum Repository {}
}

extension Campaign.Subscriber.Add.Repository {
    protocol Interface: Sendable {
        func create(newsletterId: String, form: Campaign.Subscriber.Form.Input)
            async throws
    }
}
