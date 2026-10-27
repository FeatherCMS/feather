import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Import {
    enum Presenter {}
}

extension Campaign.Subscriber.Import.Presenter {
    protocol Interface: Sendable {
        func render(newsletterId: String, error: String?) async throws
            -> HTMLResponse
    }
}
