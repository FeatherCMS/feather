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

extension Subscriber.Add {
    enum Controller {}
}

extension Subscriber.Add.Controller {
    protocol Interface: Sendable {
        func get(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        func post(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
    }
}
