import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import NewsletterApplication
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.Remove {
    enum Controller {}
}

extension Subscriber.Remove.Controller {
    protocol Interface: Sendable {
        func remove(request: Request, context: AuthenticatedRequestContext)
            async throws -> Response
    }
}
