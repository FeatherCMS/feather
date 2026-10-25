import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    enum Controller {
        protocol Interface: Sendable {
            func send(
                request: Request,
                context: AuthenticatedRequestContext
            ) async throws -> Response
        }
    }
}

