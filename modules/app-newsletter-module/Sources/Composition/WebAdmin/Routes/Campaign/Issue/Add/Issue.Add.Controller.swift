import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Issue.Add {
    enum Controller {}
}

extension Issue.Add.Controller {
    protocol Interface: Sendable {
        func get(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse
        func add(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
        func send(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response
    }
}
