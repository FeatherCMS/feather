struct AdminManageNewsletterSubscribersDefaultInteractor:
    AdminManageNewsletterSubscribersInteractor
{
    let repository: AdminManageNewsletterSubscribersOpenAPIRepository
    func list(newsletterId: String, search: String?) async throws
        -> [AdminManageNewsletterSubscriberItem]
    {
        let items = try await repository.list(newsletterId: newsletterId)
        guard let search, !search.isEmpty else { return items }
        let query = search.lowercased()
        return items.filter { item in
            item.email.lowercased().contains(query)
                || item.firstName.lowercased().contains(query)
                || item.lastName.lowercased().contains(query)
                || item.status.lowercased().contains(query)
        }
    }
    func create(newsletterId: String, form: NewsletterSubscriberForm)
        async throws
    { try await repository.create(newsletterId: newsletterId, form: form) }
    func get(newsletterId: String, subscriberId: String) async throws
        -> AdminManageNewsletterSubscriberItem
    {
        try await repository.get(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
    func update(
        newsletterId: String,
        subscriberId: String,
        form: NewsletterSubscriberForm
    ) async throws {
        try await repository.update(
            newsletterId: newsletterId,
            subscriberId: subscriberId,
            form: form
        )
    }
    func remove(newsletterId: String, subscriberId: String) async throws {
        try await repository.remove(
            newsletterId: newsletterId,
            subscriberId: subscriberId
        )
    }
    func bulkRemove(newsletterId: String, subscriberIds: [String]) async throws
    {
        for subscriberId in subscriberIds {
            try await repository.remove(
                newsletterId: newsletterId,
                subscriberId: subscriberId
            )
        }
    }
}
