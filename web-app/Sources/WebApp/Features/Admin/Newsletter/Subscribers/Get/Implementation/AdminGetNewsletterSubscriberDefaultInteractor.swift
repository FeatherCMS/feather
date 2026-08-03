struct AdminGetNewsletterSubscriberDefaultInteractor:
    AdminGetNewsletterSubscriberInteractor
{
    let repository: AdminGetNewsletterSubscriberOpenAPIRepository

    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
    {
        try await repository.get(
            subscriberId: subscriberId,
            newsletterId: newsletterId
        )
    }
}
