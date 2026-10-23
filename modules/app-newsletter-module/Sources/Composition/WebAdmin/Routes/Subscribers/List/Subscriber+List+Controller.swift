import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Subscriber.List {
    enum Controller {}
}

extension Subscriber.List.Controller {
    protocol Interface: Sendable {
        func list(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        func viewSubscriber(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
    }
}
