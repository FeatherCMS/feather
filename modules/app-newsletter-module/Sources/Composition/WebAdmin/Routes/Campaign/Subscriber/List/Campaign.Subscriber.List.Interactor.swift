import FeatherWebAdmin
import NewsletterModule

extension Campaign.Subscriber.List {
    enum Interactor {}
}

extension Campaign.Subscriber.List.Interactor {
    protocol Interface: Sendable {
        func list(newsletterId: String, search: String?, page: Int)
            async throws -> AdminListModel<Campaign.Subscriber.List.Item>
    }
}
