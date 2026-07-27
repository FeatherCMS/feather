import AdminOpenAPI

struct AdminGetNewsletterSubscriberOpenAPIRepository {
    let api: AdminAPI

    func get(subscriberId: String, newsletterId: String?) async throws
        -> AdminGetNewsletterSubscriberModel
    {
        let resolvedNewsletterId = try await resolveNewsletterId(
            subscriberId: subscriberId,
            newsletterId: newsletterId
        )
        return .init(
            newsletterId: resolvedNewsletterId,
            item: try await AdminNewsletterCampaignSubscribersAPIClient(
                api: api
            )
            .get(newsletterId: resolvedNewsletterId, subscriberId: subscriberId)
        )
    }

    private func resolveNewsletterId(
        subscriberId: String,
        newsletterId: String?
    ) async throws -> String {
        if let newsletterId, !newsletterId.isEmpty { return newsletterId }
        guard
            let id = try await AdminNewsletterSubscribersAPIClient(api: api)
                .list().first(where: { $0.id == subscriberId })?
                .newsletters.first?
                .id
        else {
            throw OpenAPIRepositoryError.notFound(
                message: "This subscriber could not be found."
            )
        }
        return id
    }
}
