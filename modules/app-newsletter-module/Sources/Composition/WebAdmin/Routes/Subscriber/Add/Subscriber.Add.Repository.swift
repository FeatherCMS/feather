import NewsletterApplication
import NewsletterModule

extension Subscriber.Add.Repository {
    protocol Interface: Sendable {
        func listCampaigns() async throws
            -> [Subscriber.List.Model.Campaign]

        func create(
            form: Subscriber.Add.Form,
            campaigns: [Subscriber.List.Model.Campaign]
        ) async throws
    }
}
