import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminEditContactFormSubmissionController: Sendable {
    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
}

extension AdminEditContactFormSubmissionController {
    func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
        router.post(
            ContactAdminRoutes.formSubmissionEditRoute,
            use: update
        )
    }
}
