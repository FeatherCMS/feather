import NewsletterModule

extension Campaign.Subscriber.Edit.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.Edit.Repository.Interface

        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
        {
            try await repository.get(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
        }

        func update(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form
        ) async throws {
            try await repository.update(
                newsletterId: newsletterId,
                subscriberId: subscriberId,
                form: form
            )
        }
    }
}
