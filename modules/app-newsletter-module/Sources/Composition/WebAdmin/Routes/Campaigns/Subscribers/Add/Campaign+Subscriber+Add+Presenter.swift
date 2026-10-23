import FeatherWebAdmin
import NewsletterModule

extension Campaign.Subscriber.Add {
    enum Presenter {}
}

extension Campaign.Subscriber.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            newsletterId: String,
            form: Campaign.Subscriber.Form,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse
    }
}
