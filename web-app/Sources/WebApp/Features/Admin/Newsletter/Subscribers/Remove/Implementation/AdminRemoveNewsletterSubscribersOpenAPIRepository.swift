import AdminOpenAPI

struct AdminRemoveNewsletterSubscribersOpenAPIRepository {
    let api: AdminAPI

    func remove(ids: [String], campaignId: String?) async throws {
        try await AdminNewsletterSubscribersAPIClient(api: api)
            .bulkRemove(subscriberIds: ids, campaignId: campaignId)
    }
}
