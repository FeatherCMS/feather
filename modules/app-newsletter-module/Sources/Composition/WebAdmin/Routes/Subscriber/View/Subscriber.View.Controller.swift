import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Subscriber.View {
    enum Controller {}
}

extension Subscriber.View.Controller {
    protocol Interface: Sendable {
        func view(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
