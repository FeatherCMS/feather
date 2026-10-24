import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule

extension Issue.View {
    enum Controller {}
}

extension Issue.View.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
