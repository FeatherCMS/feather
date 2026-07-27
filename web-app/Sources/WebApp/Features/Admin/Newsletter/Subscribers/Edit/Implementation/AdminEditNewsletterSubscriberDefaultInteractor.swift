struct AdminEditNewsletterSubscriberDefaultInteractor:
    AdminEditNewsletterSubscriberInteractor
{
    let repository: AdminEditNewsletterSubscriberOpenAPIRepository

    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
    {
        try await repository.get(
            subscriberId: subscriberId,
            newsletterId: newsletterId
        )
    }
    func update(
        subscriberId: String,
        newsletterId: String?,
        form: NewsletterSubscriberForm
    ) async throws -> AdminGetNewsletterSubscriberModel {
        try await repository.update(
            subscriberId: subscriberId,
            newsletterId: newsletterId,
            form: form
        )
    }
}
