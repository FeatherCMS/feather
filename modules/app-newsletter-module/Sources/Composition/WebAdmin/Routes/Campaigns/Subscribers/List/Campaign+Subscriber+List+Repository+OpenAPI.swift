import NewsletterModule

extension Campaign.Subscriber.List.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func list(newsletterId: String) async throws
            -> [Campaign.Subscriber.Item]
        {
            try await Campaign.Subscriber.API.Client(api: api)
                .list(
                    newsletterId: newsletterId
                )
        }
    }
}
