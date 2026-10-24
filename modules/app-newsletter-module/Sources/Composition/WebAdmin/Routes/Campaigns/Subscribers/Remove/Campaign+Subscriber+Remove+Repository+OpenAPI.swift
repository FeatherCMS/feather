import NewsletterModule

extension Campaign.Subscriber.Remove.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func remove(newsletterId: String, subscriberIds: [String]) async throws
        {
            for subscriberId in subscriberIds {
                try await Campaign.Subscriber.API.Client(api: api)
                    .remove(
                        newsletterId: newsletterId,
                        subscriberId: subscriberId
                    )
            }
        }
    }
}
