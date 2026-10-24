import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Search {
    enum Controller {}
}

extension Campaign.Search.Controller {
    protocol Interface: Sendable {
        func getSearchPage(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
