import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveNewsletterIssueController: Sendable {
    func confirm(request: Request, context: AuthenticatedRequestContext)
        async throws -> HTMLResponse

    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws -> Response
}
