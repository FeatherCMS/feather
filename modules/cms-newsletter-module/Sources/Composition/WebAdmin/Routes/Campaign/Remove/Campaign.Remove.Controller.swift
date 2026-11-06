import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Remove {
    enum Controller {}
}

extension Campaign.Remove.Controller {
    protocol Interface: Sendable {
        func remove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response

        func removeSelected(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
