import FeatherWebAdmin
import Hummingbird
import NewsletterModule

extension Subscriber.View {
    enum Presenter {}
}

extension Subscriber.View.Presenter {
    protocol Interface: Sendable {
        func render(
            model: Subscriber.View.Model,
            permissions: Set<String>
        ) async throws -> HTMLResponse
        func renderErrorPage(
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse
    }
}
