import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.List {
    enum Presenter {}
}

extension Campaign.Subscriber.List.Presenter {
    protocol Interface: Sendable {
        func render(
            newsletterId: String,
            model: AdminListModel<Campaign.Subscriber.Item>,
            search: String?,
            error: String?,
            permissions: AdminListActions
        ) async throws -> HTMLResponse
    }
}
