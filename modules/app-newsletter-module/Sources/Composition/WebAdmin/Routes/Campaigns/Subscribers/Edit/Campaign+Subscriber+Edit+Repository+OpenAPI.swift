import NewsletterModule

extension Campaign.Subscriber.Edit.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
        {
            try await Campaign.Subscriber.APIClient(api: api)
                .get(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId
                )
        }

        func update(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form.Input
        ) async throws {
            try await Campaign.Subscriber.APIClient(api: api)
                .update(
                    newsletterId: newsletterId,
                    subscriberId: subscriberId,
                    form: form
                )
        }
    }
}
