import AdminOpenAPI

struct AdminListNewsletterSubscribersOpenAPIRepository {
    let api: AdminAPI

    func campaigns() async throws -> [AdminNewsletterSubscriberCampaign] {
        try await AdminNewsletterSubscribersAPIClient(api: api).campaigns()
    }

    func list() async throws -> [AdminNewsletterSubscriberListItem] {
        try await AdminNewsletterSubscribersAPIClient(api: api).list()
    }
}
