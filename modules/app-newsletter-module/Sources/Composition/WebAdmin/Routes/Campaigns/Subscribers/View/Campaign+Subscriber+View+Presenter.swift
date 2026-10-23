import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.View {
    enum Presenter {}
}

extension Campaign.Subscriber.View.Presenter {
    protocol Interface: Sendable {
        func render(
            newsletterId: String,
            item: Campaign.Subscriber.Item
        ) async throws -> HTMLResponse
    }
}
