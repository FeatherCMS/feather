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

extension Issue.Search {
    enum Controller {
        protocol Interface: Sendable {
            func search(
                request: Request,
                context: AuthenticatedRequestContext
            ) async throws -> HTMLResponse
        }
    }
}
