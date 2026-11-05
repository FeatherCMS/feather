import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterModule

extension Campaign.Subscriber.Remove {
    enum Controller {}
}

extension Campaign.Subscriber.Remove.Controller {
    protocol Interface: Sendable {
        func post(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
