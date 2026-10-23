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

            func route(
                on router: any RouterMethods<AuthenticatedRequestContext>,
                at route: WebRoute
            )
        }
    }
}

extension Issue.Search.Controller.Interface {
    func route(
        on router: any RouterMethods<AuthenticatedRequestContext>,
        at route: WebRoute
    ) {
        router.get(route.routerPath, use: search)
    }
}
