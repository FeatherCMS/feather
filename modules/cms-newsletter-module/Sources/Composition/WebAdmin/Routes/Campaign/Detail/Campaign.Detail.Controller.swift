import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Detail {
    enum Controller {}
}

extension Campaign.Detail.Controller {
    protocol Interface: Sendable {
        func get(request: Request, context: AuthenticatedRequestContext)
            async throws -> HTMLResponse
    }
}
