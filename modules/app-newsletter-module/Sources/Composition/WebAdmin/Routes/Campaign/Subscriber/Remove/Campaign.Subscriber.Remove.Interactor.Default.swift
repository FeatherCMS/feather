import NewsletterModule

extension Campaign.Subscriber.Remove.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.Remove.Repository.Interface

        func remove(newsletterId: String, subscriberIds: [String]) async throws
        {
            try await repository.remove(
                newsletterId: newsletterId,
                subscriberIds: subscriberIds
            )
        }
    }
}
