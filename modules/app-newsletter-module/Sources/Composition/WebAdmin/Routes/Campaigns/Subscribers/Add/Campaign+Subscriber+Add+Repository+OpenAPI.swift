import NewsletterModule

extension Campaign.Subscriber.Add.Repository {
    struct OpenAPI: Interface {
        let api: API.Client

        func create(newsletterId: String, form: Campaign.Subscriber.Form.Input)
            async throws
        {
            try await Campaign.Subscriber.API.Client(api: api)
                .create(
                    newsletterId: newsletterId,
                    form: form
                )
        }
    }
}
