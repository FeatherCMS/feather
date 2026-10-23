import NewsletterModule

extension Subscriber.List.Repository {
    protocol Interface: Sendable {
        func campaigns() async throws -> [Subscriber.List.Model.Campaign]
        func list() async throws -> [Subscriber.List.Model.Item]
        func get(id: String) async throws -> Subscriber.List.Model.Item
    }
}
