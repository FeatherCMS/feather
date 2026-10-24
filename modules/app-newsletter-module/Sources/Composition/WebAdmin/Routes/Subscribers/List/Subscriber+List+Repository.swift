import NewsletterModule

extension Subscriber.List.Repository {
    struct SearchResult: Sendable {
        let items: [Subscriber.List.Model.Item]
        let total: Int
    }

    protocol Interface: Sendable {
        func campaigns() async throws -> [Subscriber.List.Model.Campaign]
        func search(
            search: String?,
            campaignKey: String?,
            page: Int
        ) async throws -> SearchResult
        func list() async throws -> [Subscriber.List.Model.Item]
        func get(id: String) async throws -> Subscriber.List.Model.Item
    }
}
