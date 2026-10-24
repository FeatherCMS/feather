import NewsletterModule

extension Campaign.Subscriber.View.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.View.Repository.Interface

        func get(newsletterId: String, subscriberId: String) async throws
            -> Campaign.Subscriber.Item
        {
            try await repository.get(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
        }
    }
}
