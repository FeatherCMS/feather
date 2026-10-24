import NewsletterModule

extension Campaign.Subscriber.View.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
        {
            try await Campaign.Subscriber.API.Client(api: api)
                .get(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId
                )
        }
    }
}
