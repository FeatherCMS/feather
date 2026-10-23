import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Edit {
    enum Presenter {}
}

extension Campaign.Subscriber.Edit.Presenter {
    protocol Interface: Sendable {
        func render(
            newsletterId: String,
            subscriberId: String,
            form: Campaign.Subscriber.Form,
            error: String?
        ) async throws -> HTMLResponse
    }
}
